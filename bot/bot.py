import os
import threading
from flask import Flask
import discord
from discord.ext import commands

# ENV VARS
DISCORD_TOKEN = os.getenv("DISCORD_TOKEN")
PORT = int(os.environ.get("PORT", 8000))

# Flask app
app = Flask(__name__)

@app.route("/")
def index():
    return "Bot is running!"

# Run Flask server in separate thread
def run_flask():
    app.run(host="0.0.0.0", port=PORT)

# Start Flask server in background
flask_thread = threading.Thread(target=run_flask)
flask_thread.start()

# Discord Bot
intents = discord.Intents.default()
intents.message_content = True  # if needed

bot = commands.Bot(command_prefix="!", intents=intents)

@bot.event
async def on_ready():
    print(f"Bot is ready. Logged in as {bot.user}")

# Your command or interaction handlers go here
# @bot.command()
# async def ping(ctx):
#     await ctx.send("Pong!")

bot.run(DISCORD_TOKEN)
