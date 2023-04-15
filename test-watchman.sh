#!/bin/sh -eu

# Test if watchman works correctly

# Create a directory /tmp/watched-dir and watch it with watchman
mkdir -p /tmp/watched-dir
watchman watch /tmp/watched-dir

echo watchman FAILED >/tmp/result.txt

# create a script file_created.sh that will be executed whenever a file is created in /tmp/watched-dir
echo "echo watchman succeeded >/tmp/result.txt" > /tmp/file_created.sh
chmod +x /tmp/file_created.sh

# now execute the command file_created.sh whenever a file is created in /tmp/watched-dir
watchman -- trigger /tmp/watched-dir file_created '*' -- /tmp/file_created.sh

# now create a file in /tmp/watched-dir and see if the command is executed
touch /tmp/watched-dir/test.txt

# wait for 1 second
sleep 1

# now remove the watch
watchman watch-del /tmp/watched-dir

# now check if the command was executed
cat /tmp/result.txt



# testing watchman-make

echo watchman-make FAILED >/tmp/result.txt

watchman-make -r "echo watchman-make succeeded >/tmp/result.txt" -p '*' --root /tmp/watched-dir/ &
pid=$!

# wait for 1 second
sleep 1

# now create a file in /tmp/watched-dir and see if the command is executed
touch /tmp/watched-dir/test2.txt

# wait for 1 second
sleep 1

# now kill watchman-make
kill $pid

# now check if the command was executed
cat /tmp/result.txt
