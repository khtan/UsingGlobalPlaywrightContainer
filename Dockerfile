# version: 2
# 1. Pull in the focal image from Playwright
FROM mcr.microsoft.com/playwright:v1.22.0-focal

# 2. Set the NODE_PATH for global install of Playwright
# Q) In theory, it would be nice to emulate export NODE_PATH=$(npm root -g)
# But evaluating and return values is not currently supported in Docker ENV
# Most solutions are currently convoluted
# See https://stackoverflow.com/questions/59076383/evaluate-bash-expression-in-dockerfile
# Just hard code NODE_PATH because the Docker is a known Linux image
ENV NODE_PATH=/usr/lib/node_modules

# 3. Install Playwright globally
RUN npm install -g @playwright/test@1.22 # Q) no need to install playwright, only playwright/test. why?

# 4. Install Playwright browsers
RUN npx playwright install

# 5. Set the working directory
# interactive usage from host typically maps the host test folder to tests here
WORKDIR tests

# 6. Define the default entry and command arguments
ENTRYPOINT ["npx"]
CMD ["playwright", "test"]
