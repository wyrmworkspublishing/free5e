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

# Discord setup
intents = discord.Intents.default()
intents.message_content = True

bot = commands.Bot(command_prefix='!', intents=intents)

@bot.event
async def on_ready():
    await bot.tree.sync()
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

@bot.command(name='define')
async def define(ctx, category: str, *, entry: str):
    try:
        category = category.strip().lower()
        entry = entry.strip()
        result = get_entry(category, entry)
        if result is not None:
            await ctx.send(f"**{result['name']}**: {result['definition']}")
        else:
            await ctx.send(f"Couldn't find a matching entry for `{entry}` in category `{category}`.")
    except Exception as e:
        logging.error(f"Error in define command: {e}")
        await ctx.send("An error occurred while processing your request.")

@bot.command(name='search')
async def search(ctx, *, search_term: str):
    try:
        search_term = search_term.strip()
        result = search_all_entries(search_term)
        if result is not None:
            await ctx.send(f"**{result['name']}**: {result['definition']}")
        else:
            await ctx.send(f"Couldn't find a matching entry for `{search_term}`.")
    except Exception as e:
        logging.error(f"Error in search command: {e}")
        await ctx.send("An error occurred while processing your request.")

@bot.command(name='categories')
async def list_categories(ctx):
    try:
        category_list = sorted(glossary.groups.keys())
        await ctx.send("**Available categories:**\n" + ", ".join(f"`{cat}`" for cat in category_list))
    except Exception as e:
        logging.error(f"Error in categories command: {e}")
        await ctx.send("An error occurred while retrieving the category list.")

@bot.command(name='glossaryhelp')
async def glossary_help(ctx):
    help_text = (
        "**Glossary Bot Commands**\n"
        "`!define [category] [entry name]` – Look up a glossary entry in a specific category.\n"
        "  Example: `!define feat resilient`\n"
        "`!search [entry name]` – Search all categories for a glossary entry.\n"
        "  Example: `!search spellcasting`\n"
        "`!categories` – List all available glossary categories.\n"
        "`!glossaryhelp` – Show this help message.\n"
        "All commands are also available as slash commands.\n"
    )
    await ctx.send(help_text)

# Slash commands
@bot.tree.command(name="define", description="Look up a glossary entry by category")
@app_commands.describe(category="The glossary category", entry="The entry name")
async def slash_define(interaction: discord.Interaction, category: str, entry: str):
    try:
        category = category.strip().lower()
        entry = entry.strip()
        result = get_entry(category, entry)
        if result is not None:
            await interaction.response.send_message(f"**{result['name']}**: {result['definition']}")
        else:
            await interaction.response.send_message(f"No match for `{entry}` in `{category}`.")
    except Exception as e:
        logging.error(f"Error in slash_define: {e}")
        await interaction.response.send_message("An error occurred while processing your request.")

@bot.tree.command(name="search", description="Search for a glossary entry in all categories")
@app_commands.describe(entry="The entry name to search for")
async def slash_search(interaction: discord.Interaction, entry: str):
    try:
        entry = entry.strip()
        result = search_all_entries(entry)
        if result is not None:
            await interaction.response.send_message(f"**{result['name']}**: {result['definition']}")
        else:
            await interaction.response.send_message(f"No match for `{entry}`.")
    except Exception as e:
        logging.error(f"Error in slash_search: {e}")
        await interaction.response.send_message("An error occurred while processing your request.")

@bot.tree.command(name="categories", description="List all available glossary categories")
async def slash_categories(interaction: discord.Interaction):
    try:
        category_list = sorted(glossary.groups.keys())
        await interaction.response.send_message("**Categories:**\n" + ", ".join(f"`{cat}`" for cat in category_list))
    except Exception as e:
        logging.error(f"Error in slash_categories: {e}")
        await interaction.response.send_message("An error occurred while retrieving the category list.")

@bot.tree.command(name="glossaryhelp", description="Show glossary bot help message")
async def slash_glossary_help(interaction: discord.Interaction):
    help_text = (
        "**Glossary Bot Commands**\n"
        "`/define [category] [entry name]` – Look up a glossary entry in a specific category.\n"
        "`/search [entry name]` – Search all categories for a glossary entry.\n"
        "`/categories` – List all available glossary categories.\n"
        "`/glossaryhelp` – Show this help message.\n"
        "These commands are also available with `!` if you prefer text commands.\n"
    )
    await interaction.response.send_message(help_text, ephemeral=True)

# Start bot
token = os.environ["DISCORD_TOKEN"]
bot.run(token)
