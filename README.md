# Local MediaWiki Setup with Wikipedia Dump

This project automates the setup of a local MediaWiki instance, including the import of a Wikipedia content dump, using Docker and Makefile.

## Prerequisites

Before you begin, ensure you have the following installed on your system:

- Docker
- Docker Compose
- wget
- bunzip2

## Installation and Setup

1. **Clone the Repository**

    ```
    git clone https://github.com/SimonasJurksa/wikipedia-localhost.git
    cd wikipedia-localhost
    ```

2. **Run the Makefile**

    The Makefile automates the setup process. Run the following command:

    ```
    make
    ```

    This command performs several actions:

    - Checks if the required tools are installed.
    - Sets up Docker containers for MediaWiki and MySQL.
    - Downloads the latest Wikipedia dump (if not already downloaded).
    - Extracts and imports the Wikipedia dump into MediaWiki.

3. **Accessing MediaWiki**

    Once the setup is complete, you can access your local MediaWiki instance by navigating to `http://localhost:8080` in your web browser.

    Complete the MediaWiki installation wizard. For database settings, use the following credentials:

    ```
    Database Host: database
    Database Name: my_wiki
    Database Username: wikiuser
    Database Password: wikipassword
    ```

## Notes

- The Wikipedia dump is large and the download and import processes can take a significant amount of time.
- The imported Wikipedia content is static and won't auto-update.
- Images and some other media from Wikipedia won't be included in the dump.

## Contributing

Contributions to this project are welcome. Please fork the repository and submit a pull request with your changes.

## License

This project is open-source and available under the [MIT License](LICENSE).
