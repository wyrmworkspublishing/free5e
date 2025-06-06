import os
import threading
import logging
from http.server import BaseHTTPRequestHandler, HTTPServer
from functools import lru_cache

import pandas as pd
from flask import Flask  # You can remove Flask entirely if you want
import discord
from discord.ext import commands
from discord import app_commands
from rapidfuzz import process

# Environment variables
DISCORD_TOKEN = os.getenv("DISCORD_TOKEN")
GUILD_ID = 1380206789525766194  # Your test server

# Minimal dummy server to keep Render alive
class HealthHandler(BaseHTTPRequestHandler):
    def do_HEAD(self):
        self.send_response(200)
        self.end_headers()
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"Bot is running!")

def run_server():
    port = int(os.environ.get("PORT", 8000))
    server = HTTPServer(("", port), HealthHandler)
    server.serve_forever()

threading.Thread(target=run_server, daemon=True).start()

# Discord setup
intents = discord.Intents.default()
intents.message_content = True
bot = commands.Bot(command_prefix='!', intents=intents)

@bot.event
async def on_ready():
    try:
        guild = discord.Object(id=GUILD_ID)
        await bot.tree.sync(guild=guild)
        print(f"Synced commands to guild {GUILD_ID}")
    except Exception as e:
        print(f"Failed to sync commands: {e}")
    print(f'Bot is ready. Logged in as {bot.user}')

# Load and sanitize glossary data
glossary_df = pd.read_csv('free5e_glossary.csv')
glossary_df['category'] = glossary_df['category'].str.strip().str.lower()
glossary_df['name'] = glossary_df['name'].str.strip()
glossary_df['definition'] = glossary_df['definition'].str.strip()
glossary = glossary_df.groupby('category')

@lru_cache(maxsize=128)
def get_entry(category: str, entry: str):
    try:
        if category in glossary.groups:
            entries = glossary.get_group(category)
            names = entries['name'].tolist()
            match = process.extractOne(entry, names)
            if match and match[1] > 70:
                return entries[entries['name'] == match[0]].iloc[0]
        return None
    except Exception as e:
        logging.error(f"Error in get_entry: {e}")
        return None

@lru_cache(maxsize=128)
def search_all_entries(term: str):
    try:
        all_entries = glossary_df['name'].tolist()
        match = process.extractOne(term, all_entries)
        if match:
            return glossary_df[glossary_df['name'] == match[0]].iloc[0]
        return None
    except Exception as e:
        logging.error(f"Error in search_all_entries: {e}")
        return None

# Text Commands
@bot.command(name='define')
async def define(ctx, category: str, *, entry: str):
    result = get_entry(category.strip().lower(), entry.strip())
    if result:
        await ctx.send(f"**{result['name']}**: {result['definition']}")
    else:
        await ctx.send(f"Couldn't find `{entry}` in `{category}`.")

@bot.command(name='search')
async def search(ctx, *, search_term: str):
    result = search_all_entries(search_term.strip())
    if result:
        await ctx.send(f"**{result['name']}**: {result['definition']}")
    else:
        await ctx.send(f"Couldn't find `{search_term}`.")

@bot.command(name='categories')
async def list_categories(ctx):
    cats = sorted(glossary.groups.keys())
    await ctx.send("**Available categories:**\n" + ", ".join(f"`{c}`" for c in cats))

@bot.command(name='glossaryhelp')
async def glossary_help(ctx):
    help_text = (
        "**Glossary Bot Commands**\n"
        "`!define [category] [entry name]`\n"
        "`!search [entry name]`\n"
        "`!categories`\n"
        "`!glossaryhelp`\n"
        "All commands are also available as slash commands."
    )
    await ctx.send(help_text)

# Slash Commands
@bot.tree.command(name="define", description="Look up a glossary entry by category")
@app_commands.describe(category="The glossary category", entry="The entry name")
async def slash_define(interaction: discord.Interaction, category: str, entry: str):
    result = get_entry(category.strip().lower(), entry.strip())
    if result:
        await interaction.response.send_message(f"**{result['name']}**: {result['definition']}")
    else:
        await interaction.response.send_message(f"No match for `{entry}` in `{category}`.")

@bot.tree.command(name="search", description="Search all categories for a glossary entry")
@app_commands.describe(entry="The entry name to search for")
async def slash_search(interaction: discord.Interaction, entry: str):
    result = search_all_entries(entry.strip())
    if result:
        await interaction.response.send_message(f"**{result['name']}**: {result['definition']}")
    else:
        await interaction.response.send_message(f"No match for `{entry}`.")

@bot.tree.command(name="categories", description="List all available glossary categories")
async def slash_categories(interaction: discord.Interaction):
    cats = sorted(glossary.groups.keys())
    await interaction.response.send_message("**Categories:**\n" + ", ".join(f"`{c}`" for c in cats))

@bot.tree.command(name="glossaryhelp", description="Show glossary bot help message")
async def slash_glossary_help(interaction: discord.Interaction):
    help_text = (
        "**Glossary Bot Commands**\n"
        "`/define [category] [entry name]`\n"
        "`/search [entry name]`\n"
        "`/categories`\n"
        "`/glossaryhelp`\n"
        "These commands are also available with `!` if you prefer text commands."
    )
    await interaction.response.send_message(help_text, ephemeral=True)

# Run the bot
bot.run(DISCORD_TOKEN)
