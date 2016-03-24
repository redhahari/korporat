-- contoh dc jakarta

SELECT  a.tglbon,
        a.nobon,
        a.kolang,
        round(a.jumharbrut,2) as jumharbrutoexppn,
        a.diskonvol,
        a.jumharnet,
        round(a.jumharbrut*1.1,2) as jumharbrutoincppn,
        a.jumhartag,
        a.kosales,
        a.fbatal,
        b.koitem,
        round(b.hargasat,2) hargasat,
        case when b.harsabruto is null or b.harsabruto = 0 then 0 --to avoid division by zero
        else round(b.hargabruto/b.harsabruto) end as qtydiserah, --qtydiserah is buggy, so i've used this method 
        b.hargabruto as hargabrutoexppn,
        round(b.hargabruto*1.1,2) as hargabrutoincppn,
        round(b.hargabruto-(b.hargabruto*(a.dispstvol/100)),2) as harganet,
        round(0.9*(b.hargabruto-(b.hargabruto*(a.dispstvol/100))),2) as hargatag
FROM jakarta.wardah_datjual_retur a
LEFT JOIN jakarta.wardah_datjual_retitem b on a.nobon=b.nobon 
WHERE a.fbatal is null and a.tglbon is null

ORDER BY a.tglbon desc

-- all dc
        
SELECT  a.tglbon,
        a.nobon,
        a.kolang,
        round(a.jumharbrut,2) as jumharbrutoexppn,
        a.diskonvol,
        a.jumharnet,
        round(a.jumharbrut*1.1,2) as jumharbrutoincppn,
        a.jumhartag,
        a.kosales,
        a.fbatal,
        b.koitem,
        round(b.hargasat,2) hargasat,
        case when b.harsabruto is null or b.harsabruto = 0 then 0 --to avoid division by zero
        else round(b.hargabruto/b.harsabruto) end as qtydiserah, --qtydiserah is buggy, so i've used this method 
        b.hargabruto as hargabrutoexppn,
        round(b.hargabruto*1.1,2) as hargabrutoincppn,
        round(b.hargabruto-(b.hargabruto*(a.dispstvol/100)),2) as harganet,
        round(0.9*(b.hargabruto-(b.hargabruto*(a.dispstvol/100))),2) as hargatag
FROM ${kota}.${merk}_datjual_retur a
LEFT JOIN ${kota}.${merk}_datjual_retitem b on a.nobon=b.nobon 
WHERE a.fbatal is null 

ORDER BY a.tglbon desc
