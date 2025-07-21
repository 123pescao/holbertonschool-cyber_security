#!/usr/bin/python3
"""read_write_heap.py: Search and replace a string in the heap of a running process."""
import sys

if len(sys.argv) != 4:
    print("Usage: read_write_heap.py pid search_string replace_string")
    exit(1)

pid = sys.argv[1]
search_str = sys.argv[2]
replace_str = sys.argv[3]

if len(replace_str) > len(search_str):
    print("Error: replace_string must not be longer than search_string")
    exit(1)

# 1. Find heap start/end in /proc/<pid>/maps
heap_start = None
heap_end = None

try:
    with open(f"/proc/{pid}/maps", "r") as maps_file:
        for line in maps_file:
            if "[heap]" in line:
                parts = line.split()
                addr_range = parts[0]
                heap_start, heap_end = [int(x, 16) for x in addr_range.split('-')]
                break
    if not heap_start or not heap_end:
        print("Error: Heap region not found.")
        exit(1)
except Exception as e:
    print(f"Error reading maps file: {e}")
    exit(1)

# 2. Open /proc/<pid>/mem and search & replace
try:
    with open(f"/proc/{pid}/mem", "rb+") as mem_file:
        mem_file.seek(heap_start)
        heap_data = mem_file.read(heap_end - heap_start)
        idx = heap_data.find(search_str.encode())
        if idx == -1:
            print(f"'{search_str}' not found in heap.")
            exit(0)
        # Overwrite at the right position
        mem_file.seek(heap_start + idx)
        mem_file.write(replace_str.encode() + b'\x00' * (len(search_str) - len(replace_str)))
        print(f"Replaced '{search_str}' with '{replace_str}' in heap.")
except PermissionError:
    print("Permission denied: Try running with sudo.")
    exit(1)
except Exception as e:
    print(f"Error accessing memory: {e}")
    exit(1)
