# imagen base de Node.js
FROM node:18-alpine AS builder

# Crea un directorio de trabajo
WORKDIR /app

# Copia los archivos package.json y package-lock.json
COPY package*.json ./

# Instala las dependencias de la aplicación
RUN npm install

#Instalar typescript globalmente en la etapa de construccion (workaround para evitar instalar net.js)
RUN npm install -g typescript

# Copia el resto de los archivos de la aplicación
COPY . .

#compilar typescript a javascript
RUN tsc 

#Etapa 2: imagen final
FROM node:18-alpine

#Establecemos el directorio de trabajo
WORKDIR /app

#Copiamos solo los archivos necesarios desde la etapa de construccion
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*json ./

# Exponemos el puerto en el que la aplicación estará corriendo
EXPOSE 3000

# Comando para iniciar la aplicación
CMD ["npm", "run", "start:dev"]
