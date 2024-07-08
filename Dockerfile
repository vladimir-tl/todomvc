# build environment
FROM node:16-alpine as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY examples/react/package.json ./
COPY examples/react/package-lock.json ./
COPY examples/react ./

RUN npm install
RUN npm install react-scripts -g --silent
RUN npm run build

  # production environment
FROM nginx:stable-alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]