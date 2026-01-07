-- Cleanup expired queues (integer milliseconds stored in `created_at`)
-- Example created_at value: 1766610610270 (milliseconds since epoch)

-- Optional: enable pg_cron (may require project owner privileges)
-- CREATE EXTENSION IF NOT EXISTS pg_cron;

CREATE OR REPLACE FUNCTION public.cleanup_expired_queues()
RETURNS void LANGUAGE plpgsql AS $$
DECLARE
  day_ms bigint := 24 * 3600 * 1000;
  cutoff bigint := (extract(epoch from now()) * 1000)::bigint - day_ms;
  r record;
BEGIN
  FOR r IN SELECT id FROM queues WHERE created_at < cutoff LOOP
    DELETE FROM queue_clients WHERE queue_id = r.id;
    DELETE FROM queues WHERE id = r.id;
  END LOOP;
END;
$$;

-- Test / run once manually in Supabase SQL editor:
-- SELECT public.cleanup_expired_queues();

-- Count older queues (integer-ms):
-- SELECT COUNT(*) FROM queues WHERE created_at < (extract(epoch from now())*1000)::bigint - 24*3600*1000;

-- Schedule with pg_cron (run hourly) example:
-- SELECT cron.schedule('cleanup_expired_queues_hourly', '0 * * * *', $$SELECT public.cleanup_expired_queues();$$);

-- Unschedule example (replace jobname if different):
-- SELECT cron.jobid, cron.jobname FROM cron.job; -- inspect
-- SELECT cron.unschedule(<jobid>);

-- Notes:
-- 1) If your DB stores `created_at` as a Postgres TIMESTAMP, use a timestamp variant instead.
-- 2) Creating extensions and scheduling jobs may require elevated permissions.
-- 3) If pg_cron isn't available, deploy an Edge Function that calls this function or directly deletes expired rows (use the service-role key).
