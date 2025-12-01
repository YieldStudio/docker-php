# YieldStudio PHP Docker Images

<p align="center">
    <a href="https://github.com/YieldStudio/docker-php/actions/workflows/action_publish-images-production.yml"><img alt="Build Status" src="https://img.shields.io/github/actions/workflow/status/YieldStudio/docker-php/.github%2Fworkflows%2Faction_publish-images-production.yml"></a>
    <a href="https://github.com/YieldStudio/docker-php/blob/main/LICENSE" target="_blank"><img src="https://badgen.net/github/license/YieldStudio/docker-php" alt="License"></a>
</p>

## Introduction

`yieldstudio/php` est un ensemble optimisé d'images Docker pour exécuter des applications PHP en production. Tout est conçu autour de l'amélioration de l'expérience développeur avec PHP et Docker. Finis les jours de configuration différente pour chaque environnement, et finis les jours où vous essayez de comprendre pourquoi votre code fonctionne dans un environnement et pas dans un autre.

Ces images sont hautement optimisées pour exécuter des applications PHP modernes, peu importe où vous souhaitez que votre application s'exécute.

Basé sur [serversideup/php](https://serversideup.net/open-source/docker-php/), ces images incluent des extensions PHP pré-configurées et des paramètres pour des performances et une sécurité améliorées. Optimisé pour Laravel et WordPress.

## Fonctionnalités

- ✅ Images basées sur PHP officiel
- ✅ Support multi-architecture (AMD64 & ARM64)
- ✅ Validation automatique des versions PHP sur DockerHub
- ✅ Support Debian (Bookworm, Trixie) et Alpine
- ✅ Variations disponibles : CLI, FrankenPHP, Sail
- ✅ Extensions PHP pré-installées (intl, gd, bcmath, exif, soap, etc.)
- ✅ Automations Laravel intégrées
- ✅ Support natif d'Octane et FrankenPHP
- ✅ Health checks intégrés

## Utilisation

Utilisez simplement ce pattern de nom d'image dans vos projets :

```sh
ghcr.io/yieldstudio/php:{{version}}-{{variation-name}}
```

Par exemple, pour PHP 8.3 avec FrankenPHP :

```sh
ghcr.io/yieldstudio/php:8.3-frankenphp
```

### Variations disponibles

| Variation     | Description                                    | Base OS              |
|---------------|------------------------------------------------|----------------------|
| `cli`         | PHP CLI de base avec extensions essentielles  | Debian (Bookworm)    |
| `frankenphp`  | Serveur FrankenPHP avec support HTTP/3         | Debian (Trixie)      |
| `sail`        | Environnement de développement Laravel Sail    | Debian (Trixie)      |

### Versions PHP supportées

- PHP 8.5
- PHP 8.4
- PHP 8.3
- PHP 8.2

## Configuration

### Variables d'environnement Laravel

Les images incluent des automations Laravel configurables via des variables d'environnement :

#### Automations générales
- `AUTORUN_ENABLED` (default: `false`) - Active les automations Laravel
- `AUTORUN_DEBUG` (default: `false`) - Active les logs de débogage

#### Storage
- `AUTORUN_LARAVEL_STORAGE_RECREATE` (default: `true`) - Recrée les dossiers de storage
- `AUTORUN_LARAVEL_STORAGE_LINK` (default: `true`) - Crée le lien symbolique de storage

#### Optimisations
- `AUTORUN_LARAVEL_OPTIMIZE` (default: `true`) - Exécute `php artisan optimize`
- `AUTORUN_LARAVEL_CONFIG_CACHE` (default: `true`) - Cache la configuration
- `AUTORUN_LARAVEL_ROUTE_CACHE` (default: `true`) - Cache les routes
- `AUTORUN_LARAVEL_VIEW_CACHE` (default: `true`) - Cache les vues
- `AUTORUN_LARAVEL_EVENT_CACHE` (default: `true`) - Cache les événements

#### Migrations
- `AUTORUN_LARAVEL_MIGRATION` (default: `true`) - Exécute les migrations
- `AUTORUN_LARAVEL_MIGRATION_DATABASE` - Base(s) de données spécifique(s)
- `AUTORUN_LARAVEL_MIGRATION_FORCE` (default: `true`) - Force les migrations
- `AUTORUN_LARAVEL_MIGRATION_TIMEOUT` (default: `30`) - Timeout de connexion DB

### Variables d'environnement PHP

- `PHP_OPCACHE_ENABLE` (default: `1`) - Active OPCache
- `PHP_VARIABLES_ORDER` (default: `"GPCS"`) - Ordre des variables PHP
- `PHP_MEMORY_LIMIT` - Limite mémoire PHP
- `PHP_UPLOAD_MAX_FILESIZE` - Taille max d'upload

## Développement local

### Construire une image

```bash
./scripts/dev.sh \
  --variation cli \
  --version 8.3 \
  --os bookworm
```

### Options disponibles

```bash
--variation <variation>   # Variation PHP (cli, frankenphp, sail)
--version <version>       # Version PHP (8.2, 8.3, 8.4, 8.5)
--os <os>                 # OS de base (bookworm, trixie, alpine)
--prefix <prefix>         # Préfixe pour le tag Docker
--registry <registry>     # Registry personnalisé
--platform <platform>     # Plateforme (linux/amd64, linux/arm64)
--push                    # Push l'image vers le registry
```

## Scripts de build

### Récupération des versions PHP

Le script [`scripts/get-php-versions.sh`](scripts/get-php-versions.sh) récupère les dernières versions PHP depuis php.net et valide leur disponibilité sur DockerHub :

```bash
./scripts/get-php-versions.sh [--skip-download] [--skip-dockerhub-validation]
```

Fonctionnalités :
- ✅ Validation automatique sur DockerHub
- ✅ Fallback vers versions antérieures si indisponible
- ✅ Annotations GitHub Actions pour warnings/erreurs
- ✅ Génération de [`scripts/conf/php-versions.yml`](scripts/conf/php-versions.yml)

### Assemblage des tags Docker

Le script [`scripts/assemble-docker-tags.sh`](scripts/assemble-docker-tags.sh) gère la logique avancée des tags Docker :

```bash
./scripts/assemble-docker-tags.sh \
  --variation <variation> \
  --os <os> \
  --patch-version <version> \
  [--stable-release] \
  [--github-release-tag <tag>]
```

Logique des tags :
- Tags patch : `8.3.1-cli-bookworm`
- Tags minor : `8.3-cli` (si dernière version patch)
- Tags major : `8-cli` (si dernière version minor)
- Tags `latest` : version stable la plus récente
- Support RC avec tags dédiés

### Génération de la matrice CI/CD

Le script [`scripts/generate-matrix.sh`](scripts/generate-matrix.sh) génère la matrice de build GitHub Actions :

```bash
./scripts/generate-matrix.sh [path/to/php-versions.yml]
```

Génère un JSON pour GitHub Actions avec toutes les combinaisons :
- Versions PHP × Variations × OS supportés
- Filtrage des versions exclues
- Tri par version (plus récentes en premier)

## Structure du projet

```
.
├── scripts/              # Scripts de build et CI/CD
│   ├── assemble-docker-tags.sh
│   ├── dev.sh
│   ├── generate-matrix.sh
│   ├── get-php-versions.sh
│   └── conf/            # Configuration PHP versions
├── src/
│   ├── common/          # Fichiers communs à toutes les variations
│   │   ├── etc/         # Scripts entrypoint et configuration
│   │   └── usr/         # Binaires personnalisés
│   └── variations/      # Dockerfiles par variation
│       ├── cli/
│       ├── frankenphp/
│       └── sail/
└── .github/
    └── workflows/       # Workflows CI/CD
```

## Contribution

Nous accueillons les contributions ! Consultez notre [guide de contribution](.github/code_of_conduct.md) pour commencer.

### Rapporter des bugs

Si vous rencontrez un problème, veuillez [créer une issue](https://github.com/YieldStudio/docker-php/issues/new/choose).

### Proposer des fonctionnalités

Améliorez ce projet en [soumettant une demande de fonctionnalité](https://github.com/YieldStudio/docker-php/discussions).

## Ressources

- **[Documentation serversideup/php](https://serversideup.net/open-source/docker-php/docs)** - Documentation complète du projet parent
- **[GitHub](https://github.com/YieldStudio/docker-php)** - Code source et gestion du projet
- **[GitHub Packages](https://github.com/YieldStudio/docker-php/pkgs/container/php)** - Registry des images

## Crédits

Ce projet est basé sur [serversideup/php](https://github.com/serversideup/docker-php) par [Server Side Up](https://serversideup.net).

Merci à toute l'équipe de Server Side Up pour leur excellent travail sur les images PHP Docker de base.

## Licence

Ce projet est sous licence [GPL-3.0-or-later](LICENSE).

---

Maintenu par [YieldStudio](https://yieldstudio.fr) | Basé sur [serversideup/php](https://serversideup.net/open-source/docker-php/)