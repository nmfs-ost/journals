#!/usr/bin/env gawk -f

function trim(value) {
    sub(/^[[:space:]]+/, "", value)
    sub(/[[:space:]]+$/, "", value)
    return value
}

function add_prefix(key) {
    return journal_suffix ":" key
}

function normalized_entry(entry) {
    gsub(/\r/, "", entry)
    gsub(/[[:blank:]]+\n/, "\n", entry)
    return entry
}

function emit_entry(    normalized) {
    normalized = normalized_entry(entry_buffer)

    if (entry_key in seen_entries) {
        if (seen_entries[entry_key] == normalized) {
            print "Removed identical duplicate entry: " entry_key > "/dev/stderr"
        } else {
            print "Removed later entry with duplicate citation key: " entry_key > "/dev/stderr"
        }
    } else {
        seen_entries[entry_key] = normalized
        printf "%s", entry_buffer
    }

    entry_buffer = ""
    entry_key = ""
    in_entry = 0
}

function rewrite_cites(text,    citation, keys, key, count, key_index, replacement, result) {
    while (match(text, /\\cite[{][^}]+[}]/)) {
        citation = substr(text, RSTART, RLENGTH)
        keys = substr(citation, 7, length(citation) - 7)
        count = split(keys, citation_keys, ",")
        replacement = "\\cite{"

        for (key_index = 1; key_index <= count; key_index++) {
            key = trim(citation_keys[key_index])
            replacement = replacement (key_index > 1 ? "," : "") add_prefix(key)
        }

        result = result substr(text, 1, RSTART - 1) replacement "}"
        text = substr(text, RSTART + RLENGTH)
    }

    return result text
}

in_entry {
    entry_buffer = entry_buffer rewrite_cites($0) ORS
    if ($0 ~ /^[[:space:]]*[})][[:space:]]*$/) {
        emit_entry()
    }
    next
}

match($0, /filename[[:space:]]*=[[:space:]]*"([^"]+[.]bib)"/, filename_match) {
    journal_suffix = filename_match[1]
    sub(/^.*[\\\/]/, "", journal_suffix)
    sub(/[.]bib$/, "", journal_suffix)
    sub(/[0-9]+$/, "", journal_suffix)
    sub(/[-_]$/, "", journal_suffix)
    sub(/^j-/, "", journal_suffix)
    gsub(/[-_]/, "", journal_suffix)
    journal_suffix = tolower(journal_suffix)
}

match($0, /^([[:space:]]*@([[:alpha:]][[:alnum:]_-]*)[[:space:]]*[{(][[:space:]]*)([^,[:space:]]+)([[:space:]]*,)/, entry_match) {
    entry_type = tolower(entry_match[2])

    if (entry_type != "preamble" && entry_type != "string" && entry_type != "comment") {
        if (journal_suffix == "") {
            print "Cannot determine journal suffix before entry " entry_match[3] > "/dev/stderr"
            exit_status = 1
            next
        }

        new_key = add_prefix(entry_match[3])
        $0 = substr($0, 1, RSTART - 1) entry_match[1] new_key entry_match[4] substr($0, RSTART + RLENGTH)
        entry_key = new_key
        entry_buffer = rewrite_cites($0) ORS
        in_entry = 1
        next
    }
}

{ print }

END {
    if (in_entry) {
        print "Unterminated entry: " entry_key > "/dev/stderr"
        exit_status = 1
    }
    exit exit_status
}