package model

import "time"

type Scrobble struct {
	MediaFileID    string
	UserID         string
	SubmissionTime time.Time
	Duration       *int // Duration in seconds the user actually listened. Nil if unknown.
}

type ScrobbleRepository interface {
	RecordScrobble(mediaFileID string, submissionTime time.Time, duration *int) error
}
