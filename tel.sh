#!/usr/bin/env bash

# Replace 'YOUR_BOT_TOKEN' with your actual bot token
BOT_TOKEN="5804393837:AAF1hlA5lhTzzldz3yJBLuOlcB2yw74pMMM"

# Replace 'YOUR_CHAT_ID' with the chat ID where you want to send the message
CHAT_ID="1406499956"

# The message you want to send
MESSAGE="Hello from your bot!"

# Send the message using the Telegram Bot API
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$CHAT_ID" -d "text=$MESSAGE"

echo "Message sent!"
