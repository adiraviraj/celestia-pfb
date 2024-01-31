SELECT 
    DATE(b.block_timestamp) AS timestamp,
    b.block_height,
    txm.message_type,
    txm.message,
    CAST(REGEXP_EXTRACT(t.fee, r'(\d+)') AS FLOAT64) / 1000000 AS tx_fee,
    CAST(JSON_EXTRACT_SCALAR(message, '$.blob_sizes[0]') AS FLOAT64) / (1024 * 1024) AS blob_size_MB,
FROM 
    `numia-data.celestia.celestia_tx_messages` txm
INNER JOIN 
    `numia-data.celestia.celestia_transactions` t ON txm.tx_id = t.tx_id 
INNER JOIN 
    `numia-data.celestia.celestia_blocks` b ON txm.block_height = b.block_height
WHERE 
    txm.message_type LIKE '%MsgPayForBl%'
ORDER BY 1 DESC