DROP VIEW IF EXISTS view_train_schedules;

CREATE VIEW view_train_schedules AS
WITH filter_parameters AS (
	SELECT TIMESTAMPTZ '2026-09-11 14:30:00-05:00' AS "FILTER_TIMESTAMP"
)
SELECT ts.id,
	   s.store_name AS destination_store,
	   ts.departure_timestamp,
	   ts.max_capacity,
	   COUNT(ta.id) AS allocated_items
FROM train_schedules AS ts
JOIN stores AS s ON ts.destination_store_id = s.id
LEFT JOIN train_allocations AS ta ON ts.id = ta.train_id
CROSS JOIN filter_parameters
WHERE ts.departure_timestamp > filter_parameters."FILTER_TIMESTAMP"
GROUP BY ts.id, s.store_name
ORDER BY ts.departure_timestamp ASC;
