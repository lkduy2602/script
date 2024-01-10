ALTER TABLE message_vote ADD end_time_virtual double precision NULL;
  
UPDATE message_vote 
SET end_time_virtual = extract(epoch from end_time);

ALTER TABLE public.message_vote DROP COLUMN end_time;
ALTER TABLE public.message_vote RENAME COLUMN end_time_virtual TO end_time;