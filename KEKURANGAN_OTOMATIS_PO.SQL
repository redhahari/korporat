
-- Standar
select 
a.kode_item_poitem,a.nama_dagang,a.nama_supplier_po,a.nomor_po,a.tanggal_po,a.jadwal_datang_po as tglkirim,a.qty_dipesan_poitem,coalesce(sum(a.qtyditrima),0) as qtyditrima,a.qty_dipesan_poitem-sum(coalesce(a.qtyditrima,0)) as outstanding_po,string_agg(cast(a.tgl_datang_terima as text),',') as tanggal_datang
from
(
  select
     t.nadagang as "nama_dagang",
     t.napabrik as "nama_pabrik", 
     p.tglpo as "tanggal_po",
     p.nopo as "nomor_po",
     p.kolang as "kode_supplier_po",
     l.nalang as "nama_supplier_po",
     p.tglserahsa as "jadwal_datang_po",
     p.tglkirim as "tgl_kirim_po",
     p.tglserah as "tgl_serah_po",
     pi.koitem as "kode_item_poitem",
     pi.kovaluta as "kode_valuta_poitem",
     pi.harsabruto as "harga_satuan_bruto_poitem",
     pi.satuantran as "satuan_transaksi",
     pi.qtydipesan as "qty_dipesan_poitem",
     pi.qtydikirim as "qty_dikirim_poitem",
     pi.qtydiserah as "qty_diserah_poitem",
     p.kogudang as "kode_gudang_po",
     pi.nopesan as "no_smbb",
     tr.notrima as "no_terima",
     tr.tgltrima as "tgl_datang_terima",
     tr.koitem as "koitem_terima",
     tr.qtyditrima as "qtyditrima",
     tr.sakecil as "qty_sakecil"
  from
      tanggerang.procure_datbeli_po p
      left join tanggerang.procure_datbeli_poitem pi on p.nopo = pi.nopo
      left join tanggerang.umum_datlogi_item t on pi.koitem=t.koitem  
      left join tanggerang.umum_datumum_pelangga l on p.kolang=l.kolang
      left join tanggerang.procure_datbeli_trima tr on tr.nopo=pi.nopo and tr.koitem=pi.koitem
) a
group by a.kode_item_poitem,a.nama_dagang,a.nama_supplier_po,a.nomor_po,a.tanggal_po,a.jadwal_datang_po,a.qty_dipesan_poitem



-- Aggregate tanpa Nomor PO

select 
a.kode_item_poitem,a.nama_dagang,a.nama_supplier_po,a.nomor_po,a.tanggal_po,a.jadwal_datang_po as tglkirim,a.qty_dipesan_poitem,coalesce(sum(a.qtyditrima),0) as qtyditrima,a.qty_dipesan_poitem-sum(coalesce(a.qtyditrima,0)) as outstanding_po,string_agg(cast(a.tgl_datang_terima as text),',') as tanggal_datang
from
(
  select
     t.nadagang as "nama_dagang",
     t.napabrik as "nama_pabrik", 
     p.tglpo as "tanggal_po",
     p.nopo as "nomor_po",
     p.kolang as "kode_supplier_po",
     l.nalang as "nama_supplier_po",
     p.tglserahsa as "jadwal_datang_po",
     p.tglkirim as "tgl_kirim_po",
     p.tglserah as "tgl_serah_po",
     pi.koitem as "kode_item_poitem",
     pi.kovaluta as "kode_valuta_poitem",
     pi.harsabruto as "harga_satuan_bruto_poitem",
     pi.satuantran as "satuan_transaksi",
     pi.qtydipesan as "qty_dipesan_poitem",
     pi.qtydikirim as "qty_dikirim_poitem",
     pi.qtydiserah as "qty_diserah_poitem",
     p.kogudang as "kode_gudang_po",
     pi.nopesan as "no_smbb",
     tr.notrima as "no_terima",
     tr.tgltrima as "tgl_datang_terima",
     tr.koitem as "koitem_terima",
     tr.qtyditrima as "qtyditrima",
     tr.sakecil as "qty_sakecil"
  from
      tanggerang.procure_datbeli_po p
      left join tanggerang.procure_datbeli_poitem pi on p.nopo = pi.nopo
      left join tanggerang.umum_datlogi_item t on pi.koitem=t.koitem  
      left join tanggerang.umum_datumum_pelangga l on p.kolang=l.kolang
      left join tanggerang.procure_datbeli_trima tr on tr.nopo=pi.nopo and tr.koitem=pi.koitem
) a
group by a.kode_item_poitem,a.nama_dagang,a.nama_supplier_po,a.nomor_po,a.tanggal_po,a.jadwal_datang_po,a.qty_dipesan_poitem

