# zensearch

> A JSON searching application

## Installation

### Prerequisites

- ruby
- bundler

### Steps

- git clone
- Move to the project folder and run `bundle`. Note that bundler needs to be installed for this.
- Add the project's bin path to the PATH environment variable. Eg.: `export PATH=$PATH:/Users/rajeevthiruvengadam/projects/zensearch/bin`

## Usage

zenseach support 3 commands:
- help
- list
- search

### The help command
```sh
$zenseach help

NAME
    zensearch - A JSON searching application

SYNOPSIS
    zensearch [global options] command [command options] [arguments...]

VERSION
    0.0.1

GLOBAL OPTIONS
    -f, --file=filename - The JSON file you would like to seach (REQUIRED) The allowed values are organizations, users, tickets (default: none)
    -g, --[no-]global   - Give the global option to run the command with all files - organizations, users, tickets
    --help              - Show this message
    --version           - Display the program version

COMMANDS
    help   - Shows a list of commands or help for one command
    list   - list the availalbe fields to searchin the JSON file specified in the file option
    search - search the JSON file specified in the file option based on a field.

```

To get help for a particular command: zensearch --help command.
Eg.

```sh
$zensearch --help search
NAME
    search - search the JSON file specified in the file option based on a field.

SYNOPSIS
    zensearch [global options] search search_field[, search_field]* search_value[, search_value]*
```

### The list command

This command is used to list the searchable fields.
Use `-g` (or `--global`) option to list the searchable fields across all files.

```sh
$zensearch -g list
x==================x
|   Organizations  |
x==================x
|   _id            |
x==================x
|   url            |
x==================x
|   external_id    |
x==================x
|   name           |
x==================x
|   domain_names   |
.
.
.
etc
```

Use `-f` (or `--file`) option to list list the searchable fields in the file specified.

```sh
$zensearch -f users list
x===================x
|        Users      |
x===================x
|   _id             |
x===================x
|   url             |
x===================x
|   external_id     |
x===================x
|   name            |
x===================x
.
.
.
etc
```

### The search command

This command can be used to search for a matching field(s) in JSON file(s).

To search globally across all files

```sh
$zensearch -g search _id 1
x=============================================================x
|                         Organizations                       |
x=============================================================x
|   Cannot find field(s) _id with value(s) 1 in organizations |
x=============================================================x
x===================x==================================================================x
|                                         Users                                        |
x===================x==================================================================x
|   _id             |   1                                                              |
x===================x==================================================================x
|   url             |   http://initech.zendesk.com/api/v2/users/1.json                 |
x===================x==================================================================x
|   external_id     |   74341f74-9c79-49d5-9611-87ef9b6eb75f                           |
x===================x==================================================================x
|   name            |   Francisca Rasmussen                                            |
.
.
.
etc
```

To search in a particular file

```sh
$zensearch -f users search _id 4
x===================x==================================================x
|                                 Users                                |
x===================x==================================================x
|   _id             |   4                                              |
x===================x==================================================x
|   url             |   http://initech.zendesk.com/api/v2/users/4.json |
x===================x==================================================x
|   external_id     |   37c9aef5-cf01-4b07-af24-c6c49ac1d1c7           |
x===================x==================================================x
|   name            |   Rose Newton                                    |
x===================x==================================================x
|   alias           |   Mr Cardenas                                    |
x===================x==================================================x
|   created_at      |   2016-02-09T07:52:10 -11:00                     |
x===================x==================================================x
.
.
.
etc
```

To search for fields that have empty value use ""

```sh
$zensearch -f tickets search description ""
x===================x=======================================================================================x
|                                                   Tickets                                                 |
x===================x=======================================================================================x
|   _id             |   4cce7415-ef12-42b6-b7b5-fb00e24f9cc1                                                |
x===================x=======================================================================================x
|   url             |   http://initech.zendesk.com/api/v2/tickets/4cce7415-ef12-42b6-b7b5-fb00e24f9cc1.json |
x===================x=======================================================================================x
|   external_id     |   ef665694-aa3f-4960-b264-0e77c50486cf                                                |
x===================x=======================================================================================x
.
.
.
etc
```

To search with multiple conditions, use comma as a delimiter

```sh
$zensearch -f users search role,locale admin,en-AU
x===================x==================================================================x
|                                         Users                                        |
x===================x==================================================================x
|   _id             |   1                                                              |
x===================x==================================================================x
|   url             |   http://initech.zendesk.com/api/v2/users/1.json                 |
x===================x==================================================================x
|   external_id     |   74341f74-9c79-49d5-9611-87ef9b6eb75f                           |
x===================x==================================================================x
|   name            |   Francisca Rasmussen                                            |
x===================x==================================================================x
|   alias           |   Miss Coffey                                                    |
x===================x==================================================================x
.
.
.
etc

```


