import json
import collections

def clean_arb(file_path):
    print(f"Cleaning {file_path}...")
    with open(file_path, 'r', encoding='utf-8') as f:
        # We can't just use json.load because it will automatically handle duplicates (usually last one wins)
        # and we want to identify them.
        content = f.read()
        
    # Simple manual parser to find duplicate keys and their values
    import re
    # Match "key": "value" patterns. Note: this is a simplification but should work for ARB.
    # ARB files also have keys starting with @ (metadata).
    # We want to keep the structure.
    
    try:
        data = json.loads(content, object_pairs_hook=collections.OrderedDict)
    except Exception as e:
        print(f"Error parsing JSON: {e}")
        return

    seen_keys = set()
    duplicates = []
    clean_data = collections.OrderedDict()
    
    # Reload with a custom hook to detect duplicates
    def detect_duplicates(pairs):
        res = collections.OrderedDict()
        for k, v in pairs:
            if k in res:
                if res[k] != v:
                    print(f"  WARNING: Duplicate key '{k}' has different values!")
                    print(f"    Existing: {res[k]}")
                    print(f"    New: {v}")
                else:
                    # Identical value, just a duplicate
                    pass
                duplicates.append(k)
            res[k] = v
        return res

    data = json.loads(content, object_pairs_hook=detect_duplicates)
    
    if duplicates:
        print(f"  Found {len(duplicates)} duplicate keys.")
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        print(f"  Cleaned {file_path} (kept the last occurrence of each key).")
    else:
        print(f"  No duplicates found in {file_path}.")

if __name__ == "__main__":
    clean_arb('lib/core/localization/l10n/app_en.arb')
    clean_arb('lib/core/localization/l10n/app_ar.arb')
