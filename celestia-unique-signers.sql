SELECT 
    DISTINCT(JSON_EXTRACT_SCALAR(message, '$.signer')) AS signer
FROM 
    `numia-data.celestia.celestia_tx_messages` txm
INNER JOIN 
    `numia-data.celestia.celestia_transactions` t ON txm.tx_id = t.tx_id 
INNER JOIN 
    `numia-data.celestia.celestia_blocks` b ON txm.block_height = b.block_height
WHERE 
    txm.message_type LIKE '%MsgPayForBl%'
ORDER BY 1 DESC