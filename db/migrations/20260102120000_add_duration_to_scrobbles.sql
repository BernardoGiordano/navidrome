-- +goose Up
-- +goose StatementBegin
ALTER TABLE scrobbles ADD COLUMN duration INTEGER;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
ALTER TABLE scrobbles DROP COLUMN duration;
-- +goose StatementEnd
