package tests

import (
	"context"
	"time"

	"github.com/navidrome/navidrome/model"
	"github.com/navidrome/navidrome/model/id"
	"github.com/navidrome/navidrome/model/request"
)

type MockScrobbleRepo struct {
	RecordedScrobbles []model.Scrobble
	ctx               context.Context
}

func (m *MockScrobbleRepo) RecordScrobble(fileID string, submissionTime time.Time, duration *int) (string, error) {
	user, _ := request.UserFrom(m.ctx)
	scrobbleID := id.NewRandom()
	m.RecordedScrobbles = append(m.RecordedScrobbles, model.Scrobble{
		ID:             scrobbleID,
		MediaFileID:    fileID,
		UserID:         user.ID,
		SubmissionTime: submissionTime,
		Duration:       duration,
	})
	return scrobbleID, nil
}

func (m *MockScrobbleRepo) UpdateDuration(scrobbleID string, duration int) error {
	for i := range m.RecordedScrobbles {
		if m.RecordedScrobbles[i].ID == scrobbleID {
			m.RecordedScrobbles[i].Duration = &duration
			break
		}
	}
	return nil
}
