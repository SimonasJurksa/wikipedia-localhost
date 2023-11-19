# Makefile to automate the setup of a local MediaWiki instance with Wikipedia dump

# The 'all' target will first check the system and then execute all other targets in sequence.
all: check-system docker-up download-wiki-dump import-wiki-dump

# Check if the system has the required tools installed
check-system:
	# Check for Docker
	@echo "Checking if Docker is installed..."
	@which docker > /dev/null || (echo "Docker is not installed. Please install it first using: sudo apt install docker.io"; exit 1)

	# Check for Docker Compose
	@echo "Checking if Docker Compose is installed..."
	@which docker-compose > /dev/null || (echo "Docker Compose is not installed. Please install it first using: sudo apt install docker-compose"; exit 1)

	# Check for wget
	@echo "Checking if wget is installed..."
	@which wget > /dev/null || (echo "wget is not installed. Please install it first using: sudo apt install wget"; exit 1)

	# Check for bunzip2
	@echo "Checking if bunzip2 is installed..."
	@which bunzip2 > /dev/null || (echo "bunzip2 is not installed. Please install it first using: sudo apt install bzip2"; exit 1)

# Create the docker-compose.yml configuration file for MediaWiki and MySQL
docker-up:
	@echo "Creating docker-compose.yml file..."
	@echo "version: '3'" > docker-compose.yml
	@echo "services:" >> docker-compose.yml
	@echo "  mediawiki:" >> docker-compose.yml
	@echo "    image: mediawiki" >> docker-compose.yml
	@echo "    ports:" >> docker-compose.yml
	@echo "      - 8080:80" >> docker-compose.yml
	@echo "    links:" >> docker-compose.yml
	@echo "      - database" >> docker-compose.yml
	@echo "    volumes:" >> docker-compose.yml
	@echo "      - ./html/:/var/www/html/images" >> docker-compose.yml
	@echo "      - ./latest-wiki-dump.xml:/var/www/html/maintenance/latest-wiki-dump.xml" >> docker-compose.yml # Mount Wikipedia dump file
	@echo "  database:" >> docker-compose.yml
	@echo "    image: mysql:5.7" >> docker-compose.yml
	@echo "    environment:" >> docker-compose.yml
	@echo "      MYSQL_DATABASE: my_wiki" >> docker-compose.yml
	@echo "      MYSQL_USER: wikiuser" >> docker-compose.yml
	@echo "      MYSQL_PASSWORD: wikipassword" >> docker-compose.yml
	@echo "      MYSQL_RANDOM_ROOT_PASSWORD: 'yes'" >> docker-compose.yml
	@echo "Starting Docker containers..."
	@docker-compose up -d

# Download the latest Wikipedia XML dump
download-wiki-dump:
	@echo "Checking if the latest Wikipedia dump is already downloaded..."
	@if [ ! -f "latest-wiki-dump.xml.bz2" ]; then \
		echo "Downloading latest Wikipedia dump. This will take a while..."; \
		echo "While you download, go to locahost:8080 and finish the wizart."; \
		echo "At the last step you will download LocalSettings.php file. Place it in the root directory"; \
		wget -O latest-wiki-dump.xml.bz2 "https://dumps.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles.xml.bz2"; \
	else \
		echo "Latest Wikipedia dump already downloaded. Skipping download."; \
	fi
# Import the Wikipedia XML dump into the MediaWiki database
import-wiki-dump:
	# Extract the Wikipedia dump
	@echo "Extracting Wikipedia dump..."
	@bunzip2 -c latest-wiki-dump.xml.bz2 > latest-wiki-dump.xml

	# Import the dump into the MediaWiki database
	@echo "Importing Wikipedia dump into MediaWiki. This may take a long time... A VERY LONG TIME!!!!!!!!!!!!!!!!!!!!!!!!!"
	@echo "NOTE: you can stop and resume the import process by pressing CTRL+C and then running 'make import-dump'"
	@docker exec -it $$(docker ps --filter "ancestor=mediawiki" -q) bash -c "cd /var/www/html/maintenance && php importDump.php < latest-wiki-dump.xml"

import-dump:
	@docker exec -it $$(docker ps --filter "ancestor=mediawiki" -q) bash -c "cd /var/www/html/maintenance && php importDump.php < latest-wiki-dump.xml"
