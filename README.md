# Sonarr-External-Audio-parser

Simple Sonarr and Radarr external Audio parser.

It will import whatever `mka`, `mp3`, `srt` and `ass` files. Rename them according to the current Sonarr naming.

[Sonarr](https://github.com/Sonarr/Sonarr) and [Radarr](https://github.com/Radarr/Radarr) are supported.

## Usage

- You have to place it in some folder that is accessible for Sonarr. E.g. save script under `/usr/local/bin/sonarr_external_import.sh` and make it executable `chmod +x /usr/local/bin/sonarr_external_import.sh`
- Then create custom connection in Sonarr **Settings** > **Connect** > **Custom Script**
- Select On File import only.

You can edit `DEFAULT_LANG` value to your expected. Script does not know language of provided Audio files so you have to set it manually.

### Docker

Save script under `/usr/local/bin/sonarr_external_import.sh` and make it executable `chmod +x /usr/local/bin/sonarr_external_import.sh`

Add script to the Sonarr, e.g. example with docker compose:

```yaml
  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    volumes:
      # External Script
      - /usr/local/bin/sonarr_external_import.sh:/usr/local/bin/sonarr_external_import.sh:ro
```

Then create custom connection in Sonarr **Settings** > **Connect** > **Custom Script**, set path to `/usr/local/bin/sonarr_external_import.sh`, select On File import only and test it.

### Supported folder structure

```plain
├─ Sound [MC-Ent]
│   └─ Show Name.mka
├─ Sub [MC-Ent]
│   └─ Show Name.srt
└─ Show Name.mkv
```

```plain
├─ Sound
│   └─ Show Name - S01E01.mka
├─ Sub
│   └─ Show Name - S01E01.srt
└─ Show Name - S01E01.mkv
```

```plain
├─ Show Name - S01E01.mka
├─ Show Name - S01E01.srt
└─ Show Name - S01E01.mkv
```

#### Destination folder structure

```plain
├─ Sonarr Show Name.mkv
├─ Sonarr Show Name.mka
└─ Sonarr Show Name.srt
```
