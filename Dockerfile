# version: 2
FROM mcr.microsoft.com/playwright:focal
# Q) In theory, it would be nice to emulate export NODE_PATH=$(npm root -g)
# But evaluating and return values is not currently supported in Docker ENV
# Most solutions are currently convoluted
# See https://stackoverflow.com/questions/59076383/evaluate-bash-expression-in-dockerfile
# Just hard code NODE_PATH because the Docker is a known Linux image
ENV NODE_PATH=/usr/lib/node_modules
RUN npm install -g @playwright/test # no need to install playwright, only playwright/test. why?
RUN npx playwright install
WORKDIR tests
ENTRYPOINT ["npx"]
CMD ["playwright", "test"]
