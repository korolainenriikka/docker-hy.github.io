FROM node:18 as build-stage

WORKDIR /usr/src/app

COPY package* ./

RUN npm ci

COPY . .

RUN npm run swizzle docusaurus-lunr-search SearchBar -- --eject --danger

RUN npm run build

FROM node:alpine

ENV PORT 80

RUN npm install -g serve

COPY --from=build-stage /usr/src/app/build /usr/src/html

# select this container to be monitored by watchtower
LABEL com.centurylinklabs.watchtower.enable="true"

CMD serve -l $PORT /usr/src/html
