
select    
          z.*,
          case when (z.qty_stok_early_dc+z.qty_otw+z.qty_ndc)<z.dailyforecast then 'Express'
          else 'Reguler'
          end as klasifikasi_order,
          (ceil(z.qty_order/coalesce(nullif(z.koli,0),1))*coalesce(z.koli,1)) as qtyorder_koli
          from 
               (select
               g.*,
               case when g.produk = 'wardah' then g.qtyorder_factor
                    when g.produk = 'mo' then 
                                               case when (select day_name from dim_time where date = g.tanggal_ndc + interval '1 day') = 'Tuesday'
                                               then g.qtyorder_factor
                                               when (g.qty_stok_early_dc + g.qtydipesan_co_dc) <= g.weeklyforecast then g.qtyorder_factor
                                               else 0
                                               end
                    when g.produk = 'emina' then 
                                               case when (select day_name from dim_time where date = g.tanggal_ndc + interval '1 day') = 'Wednesday'
                                               then g.qtyorder_factor
                                               when (g.qty_stok_early_dc + g.qtydipesan_co_dc) <= g.weeklyforecast then g.qtyorder_factor
                                               else 0
                                               end 
                    when g.produk = 'ix' then 
                                               case when (select day_name from dim_time where date = g.tanggal_ndc + interval '1 day') = 'Thursday'
                                               then g.qtyorder_factor
                                               when (g.qty_stok_early_dc + g.qtydipesan_co_dc) <= g.weeklyforecast then g.qtyorder_factor
                                               else 0
                                               end 
                    when g.produk = 'putri' then 
                                               case when (select day_name from dim_time where date = g.tanggal_ndc + interval '1 day') = 'Wednesday' or (select day_name from dim_time where date = g.tanggal_ndc + interval '1 day') = 'Friday'
                                               then g.qtyorder_factor
                                               when (g.qty_stok_early_dc + g.qtydipesan_co_dc) <= g.weeklyforecast then g.qtyorder_factor
                                               else 0
                                               end 
                    else 0
                    end as qty_order from
                                   
                                   (select
                                   b.kolang,
                                   b.koitem,
                                   b.dc,
                                   b.produk,
                                   b.koli,
                                   b.dailyforecast,
                                   b.weeklyforecast,
                                   b.list_price,
                                   b.qty_otw,
                                   b.qty_ndc,
                                   b.tanggal_ndc,
                                   b.qty_stok_early_dc,
                                   (coalesce(b.std_stock,0)-coalesce(b.qty_otw,0)-coalesce(b.qty_ndc,0)-coalesce(b.qty_stok_early_dc,0)+coalesce(r.qtydipesan,0)) as qtyorder_factor,
                                   (-coalesce(b.std_stock,0)+coalesce(b.qty_otw,0)+coalesce(b.qty_ndc,0)+coalesce(b.qty_stok_early_dc,0)-coalesce(r.qtydipesan,0)) as kelebihan_stock_dc,
                                   coalesce(b.std_stock,0) std_stock_dc,
                                   r.tglcor as tglcor_dc,
                                   i.nadagang as nadagang,
                                   coalesce(r.qtydipesan,0) as qtydipesan_co_dc,
                                   sn.qty as stock_ndc
                                   from
                                             (select a.*,
                                             coalesce(s.qty_early,0) as qty_stok_early_dc
                                             from
                                                  (select
                                                       p.kolang,
                                                       p.koitem,
                                                       p.dc,
                                                       p.produk,
                                                       p.std_stock,
                                                       p.koli,
                                                       p.dailyforecast,
                                                       p.weeklyforecast,
                                                       p.list_price,
                                                       round(sum(p.qty_otw),2) qty_otw,
                                                       round(sum(p.qty_ndc),2) qty_ndc,
                                                       cast(current_date - interval '1 day' as date) as tanggal_ndc
                                                       from ppic_co_faktur_ndc p
                                                       group by p.kolang,p.koitem,p.dc,p.produk,p.std_stock,p.koli,p.dailyforecast,p.weeklyforecast,p.list_price
                                                  ) a
                                                  left join stok_gudang_recent_month s 
                                                  on s.koitem=a.koitem and a.dc=s.kota and s.tanggal_early=a.tanggal_ndc
                                             ) b
                                        left join dc_datlogi_item i on b.koitem=i.koitem
                                        left join rp_stock_match r on r.dc=b.dc and r.koitem = b.koitem and r.tglcor = b.tanggal_ndc
                                        left join ppic_stock_ndc sn on sn.koitem = b.koitem and sn.tanggal_stock_ndc = b.tanggal_ndc
                                   ) g
                    ) z 


#CO FAKTUR

select
ccoritem.nocor nocor,
ccoritem.kolang kolang,
ccoritem.tglcor tglcor,
k.koitem koitem,
k.list_price list_price,
ccoritem.qtydipesan qtydipesan_co,
item.brand produk,
bbonitem.tglbon tglbon,
ccoritem.hargabruto hargabruto_co,
bbonitem.hargabruto hargabruto_faktur,
bbonitem.tglkirim tglkirim,
bbonitem.tglserah tglserah,
pbr.tgl as tglinput,
case when bbonitem.qtydipesan > ccoritem.qtydipesan then ccoritem.qtydipesan
else bbonitem.qtydipesan end as  qtydipesan_faktur,
bbonitem.qtydikirim qtydikirim,
bbonitem.qtydiserah qtydiserah,
case when (bbonitem.tglbon is not null and bbonitem.tglkirim is null and pbr.tgl is null) then 'NDC' 
     when (bbonitem.tglbon is not null and bbonitem.tglkirim is not null and pbr.tgl is null) then 'OTW DC'
     when (bbonitem.tglbon is not null and bbonitem.tglkirim is not null and pbr.tgl is not null) then 'DC'
     when (bbonitem.tglbon is null) then 'CO'
end as status,
case when (bbonitem.tglbon is not null and bbonitem.tglkirim is null and pbr.tgl is null) then bbonitem.qtydipesan else 0 
end as qty_ndc,
case when (bbonitem.tglbon is not null and bbonitem.tglkirim is not null and pbr.tgl is null) then bbonitem.qtydikirim else 0
end as qty_otw,
case when (bbonitem.tglbon is not null and bbonitem.tglkirim is not null and pbr.tgl is not null) then bbonitem.qtydiserah else 0
end as qty_dc,
bbonitem.nobon nobon,
k.dc as dc,
round(coalesce(k.umur_stock*ceil((k.weeklyforecast/7)),0),0) as std_stock,
round(ceil((k.weeklyforecast/7)),0) as dailyforecast,
round(k.koli,0) as koli,
round(k.weeklyforecast,0) as weeklyforecast

from 
public.dim_weeklyforecast_umurstok_koli k
left join dc_datlogi_item item on item.koitem = k.koitem 
left join (select case when split_part(nalang, ' ', 1) = 'Yogyakarta' then 'Jogjakarta' when split_part(nalang, ' ', 1) = 'Tasik' then 'Tasikmalaya' when split_part(nalang, ' ', 1) = 'Makassar' then 'Makasar' else split_part(nalang, ' ', 1) end as nama_dc,* from dc_pelangga_area_a where dc='Tanggerang' and nalang like '%Distribution Centre') p 
on p.nama_dc=k.dc
left join
(select * from ppic_ccoritem_ndc where tglcor between current_date - interval '1 month' and cast(now() at time zone 'gmt-7' as date) - interval '1 day') ccoritem 
on k.koitem = ccoritem.koitem and p.kolang = ccoritem.kolang 
left join public.ppic_bbonitem_ndc bbonitem
on ccoritem.nocor = bbonitem.nopesan and ccoritem.koitem = bbonitem.koitem
left join public.ppic_pindahbr pbr
on pbr.koitem = ccoritem.koitem and pbr.nosmb = bbonitem.nobon and pbr.dc = p.nama_dc
