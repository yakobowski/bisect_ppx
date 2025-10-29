from playwright.sync_api import sync_playwright
import os

def run(playwright):
    browser = playwright.chromium.launch()
    page = browser.new_page()

    # Get the absolute path to the index.html file
    index_path = os.path.abspath("_coverage/index.html")

    page.goto(f"file://{index_path}")

    # Click the tree view checkbox
    page.locator("#tree-view-input").check()

    # Take a screenshot
    page.screenshot(path="jules-scratch/verification/tree_view.png")

    browser.close()

with sync_playwright() as playwright:
    run(playwright)
