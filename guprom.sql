SELECT 
    '${kota}' as dc,
    '${merk}' as brand,
    cast(current_timestamp at time zone 'gmt -7' as date) as "date",
    koitem,
    qty
FROM ${kota}.${merk}_datprju_gudang_guprom1
