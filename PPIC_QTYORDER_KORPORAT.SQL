select
ccoritem.nocor nocor,
ccoritem.kolang kolang,
ccoritem.tglcor tglcor,
k.koitem koitem,
ccoritem.qtydipesan qtydipesan_co,
ccoritem.produk produk,
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
p.nama_dc as dc
from 
public.ppic_dim_koitem k
left join
(select * from ppic_ccoritem_ndc where tglcor between '2015-11-01' and cast(now() at time zone 'gmt-7' as date) - interval '1 day') ccoritem 
on k.koitem = ccoritem.koitem
left join public.ppic_bbonitem_ndc bbonitem
on ccoritem.nocor = bbonitem.nopesan and ccoritem.koitem = bbonitem.koitem
left join (select case when split_part(nalang, ' ', 1) = 'Yogyakarta' then 'Jogjakarta' when split_part(nalang, ' ', 1) = 'Tasik' then 'Tasikmalaya' when split_part(nalang, ' ', 1) = 'Makassar' then 'Makasar' else split_part(nalang, ' ', 1) end as nama_dc,* from dc_pelangga_area where dc='Tanggerang' and nalang like '%Distribution Centre') p 
on p.kolang=ccoritem.kolang
left join public.ppic_pindahbr pbr
on pbr.koitem = ccoritem.koitem and pbr.nosmb = bbonitem.nobon and pbr.dc = p.nama_dc
