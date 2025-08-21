import os
from telegram.ext import Application, MessageHandler, filters

BOT_TOKEN = os.getenv("BOT_TOKEN")
CHANNEL_ID = os.getenv("CHANNEL_ID", "@autoamerica_nik")

application = Application.builder().token(BOT_TOKEN).build()

# Проверка VIN
def is_vin(text: str) -> bool:
    return len(text) == 17 and text.isalnum()

# Заглушка функции расчёта (сюда потом подключим API)
def calculate_vin(vin: str) -> str:
    return f"Рассчитано для VIN: {vin}\nЦена: $15,000\nЦена в рублях: 1,450,000₽"

# Обработка текста
async def handle_text(update, context):
    text = update.message.text.strip().upper()
    if is_vin(text):
        result = calculate_vin(text)
        await context.bot.send_message(
            chat_id=CHANNEL_ID,
            text=result,
            parse_mode="Markdown"
        )

text_handler = MessageHandler(filters.TEXT & ~filters.COMMAND, handle_text)
application.add_handler(text_handler)

if __name__ == "__main__":
    application.run_polling()
