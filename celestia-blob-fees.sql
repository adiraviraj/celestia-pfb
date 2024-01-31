SELECT 
    DATE(b.block_timestamp) AS timestamp,
    b.block_height,
    txm.message_type,
    txm.message,
    CAST(REGEXP_EXTRACT(t.fee, r'(\d+)') AS FLOAT64) / 1000000 AS tx_fee,
    JSON_EXTRACT_SCALAR(message, '$.blob_sizes[0]') AS blob_size,
    -- (CAST(JSON_EXTRACT_SCALAR(message, '$.blob_sizes[0]') AS FLOAT64) * 8 * 0.002) AS calculated_value,
    ((CAST(JSON_EXTRACT_SCALAR(message, '$.blob_sizes[0]') AS FLOAT64) * 8 * 0.002) / 1000000) AS blob_fees
FROM 
    `numia-data.celestia.celestia_tx_messages` txm
INNER JOIN 
    `numia-data.celestia.celestia_transactions` t ON txm.tx_id = t.tx_id 
INNER JOIN 
    `numia-data.celestia.celestia_blocks` b ON txm.block_height = b.block_height
WHERE 
    txm.message_type LIKE '%MsgPayForBl%'
ORDER BY 1 DESC