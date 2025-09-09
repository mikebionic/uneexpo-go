include .env

dev:
	@go run cmd/uneexpo/main.go

db:
	@echo "Initializing uneexpo database..."
	@bash ./scripts/re-init-db.sh
#	@PGPASSWORD=$(DB_PASSWORD) psql -h $(DB_HOST) -p $(DB_PORT) -U $(DB_USER) -d postgres \
#    -f ./schemas/0.0.5_drop_db.sql

build:
	@echo "Building the app, please wait..."
	@go build -o ./bin/uneexpo cmd/uneexpo/main.go
	@echo "Done."
build-cross:
	@echo "Bulding for windows, linux and macos (darwin m2), please wait..."
	@GOOS=linux GOARCH=amd64 go build -o ./bin/uneexpo-linux cmd/uneexpo/main.go
	@GOOS=darwin GOARCH=arm64 go build -o ./bin/uneexpo-macos cmd/uneexpo/main.go
	@GOOS=windows GOARCH=amd64 go build -o ./bin/uneexpo-windows cmd/uneexpo/main.go
	@echo "Done."

upload-dir:
	@mkdir -p $(UPLOAD_PATH) || (echo "Error: Failed to create directory $(UPLOAD_PATH)" && exit 1)
	@echo "Directory $(UPLOAD_PATH) created"

init-sys:
	@mkdir -p ~/uneexpo_backend/app/
	@cp -r ~/uneexpo_backend/uneexpo/assets/ ~/uneexpo_backend/app/
	@cp ~/uneexpo_backend/uneexpo/.env.example ~/uneexpo_backend/app/.env
	@sudo cp scripts/uneexpo.service /etc/systemd/system/uneexpo.service