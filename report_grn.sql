select 
trima.tgltrima as "Tanggal GRN",
po.tglpo as "Tanggal PO",
trima.kolang as "Kode Pelanggan",
trima.nopo as "Nomor PO",
trima.koitem as "Kode Item",
trima.qtyditrima as "Quantity Diterima",
po.top as "TOP",
case when po.top = -1 then 'TRUE'
else 'FALSE' end as "Advance Payment",
po.jumhartag as "Nominal Jumlah Harga Tagih Per PO",
po.tglinq as "Tanggal Inquiry",
po.tglserahsa as "Tanggal Serahsa",
concat_ws('  ',po.catatan1,po.catatan2,po.catatan3,po.catatan3,po.catatan4,po.catatan4,po.catatan5) as "Keterangan"

from tanggerang.procure_datbeli_trima trima
left join tangggerang.procure_datbeli_po po on trima.nopo=po.nopo
