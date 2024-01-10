-- Chuyển kiểu dữ liệu end_time: timestamp -> double precision
ALTER TABLE message_vote ADD end_time_virtual DOUBLE PRECISION NULL;

UPDATE message_vote
SET
    end_time_virtual = EXTRACT(
        epoch
        FROM
            end_time
    );

ALTER TABLE public.message_vote
DROP COLUMN end_time;

ALTER TABLE public.message_vote
RENAME COLUMN end_time_virtual TO end_time;

-- xóa các record bị trùng, chỉ giữ lại row trùng có id nhỏ nhất
DELETE FROM friends
WHERE
    (user_id, user_friend_id, TYPE, id) NOT IN (
        SELECT
            user_id,
            user_friend_id,
            TYPE,
            MIN(id) AS min_id
        FROM
            friends
        GROUP BY
            user_id,
            user_friend_id,
            TYPE
    );

-- xóa các record 1 chiều
DELETE FROM friends f1
WHERE
    NOT EXISTS (
        SELECT
            *
        FROM
            friends f2
        WHERE
            f1.user_id = f2.user_friend_id
            AND f1.user_friend_id = f2.user_id
    );