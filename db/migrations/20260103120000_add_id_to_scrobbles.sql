-- +goose Up
-- +goose StatementBegin
ALTER TABLE scrobbles ADD COLUMN id VARCHAR(255);

-- Generate IDs for existing rows
UPDATE scrobbles SET id = lower(hex(randomblob(16))) WHERE id IS NULL;

-- Make id NOT NULL and primary key by recreating the table
CREATE TABLE scrobbles_new(
    id VARCHAR(255) PRIMARY KEY NOT NULL,
    media_file_id VARCHAR(255) NOT NULL
        REFERENCES media_file(id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    user_id VARCHAR(255) NOT NULL 
        REFERENCES user(id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    submission_time INTEGER NOT NULL,
    duration INTEGER
);

INSERT INTO scrobbles_new (id, media_file_id, user_id, submission_time, duration)
SELECT id, media_file_id, user_id, submission_time, duration FROM scrobbles;

DROP TABLE scrobbles;
ALTER TABLE scrobbles_new RENAME TO scrobbles;

CREATE INDEX scrobbles_date ON scrobbles (submission_time);
CREATE INDEX scrobbles_user_track ON scrobbles (user_id, media_file_id);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
CREATE TABLE scrobbles_old(
    media_file_id VARCHAR(255) NOT NULL
        REFERENCES media_file(id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    user_id VARCHAR(255) NOT NULL 
        REFERENCES user(id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    submission_time INTEGER NOT NULL,
    duration INTEGER
);

INSERT INTO scrobbles_old (media_file_id, user_id, submission_time, duration)
SELECT media_file_id, user_id, submission_time, duration FROM scrobbles;

DROP TABLE scrobbles;
ALTER TABLE scrobbles_old RENAME TO scrobbles;

CREATE INDEX scrobbles_date ON scrobbles (submission_time);
-- +goose StatementEnd
