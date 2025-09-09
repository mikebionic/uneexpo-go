package utils

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"uneexpo/config"
)

func SendOTPSMS(phoneNumber, code, firmware string) error {
	var messageCode string

	if firmware == "android" {
		messageCode = fmt.Sprintf("%s\n%s: %s", code, config.ENV.APP_NAME, config.ENV.OTP_ANDROID_HASH)
	} else {
		messageCode = fmt.Sprintf("%s\n%s", code, config.ENV.APP_NAME)
	}

	payload := map[string]string{
		"code":        fmt.Sprintf("%s%s", config.ENV.OTP_SERVICE_TEXT, messageCode),
		"phoneNumber": phoneNumber,
	}

	jsonBody, err := json.Marshal(payload)
	if err != nil {
		return fmt.Errorf("failed to marshal JSON: %w", err)
	}

	client := &http.Client{
		Timeout: 10 * time.Second,
	}

	req, err := http.NewRequest("POST", config.ENV.OTP_SERVICE_ROUTE, bytes.NewBuffer(jsonBody))
	if err != nil {
		return fmt.Errorf("failed to create request: %w", err)
	}

	req.Header.Set("Content-Type", "application/json")

	resp, err := client.Do(req)
	if err != nil {
		return fmt.Errorf("failed to send SMS request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("SMS service responded with status: %d", resp.StatusCode)
	}

	return nil
}
