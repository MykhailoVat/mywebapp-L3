import { Pool } from 'pg';
import dotenv from 'dotenv';
import path from 'path'
import { fileURLToPath } from 'url'
import fs from "node:fs";

let host
let port
let user
let password
let name

if (process.env.NODE_ENV === 'development') {
    const __dirname = path.dirname(fileURLToPath(import.meta.url))

    const envpath = path.resolve(__dirname, '../../.env.db.t')

    if (!envpath) {
        throw new Error(`envpath is not defined. Make sure you have .env files created (read docu)`)
    }

    dotenv.config({
        path: envpath
    })

    host = process.env.DB_HOST
    port = process.env.DB_PORT
    user = process.env.DB_USER
    password = process.env.DB_PASSWORD
    name = process.env.DB_NAME
} else {
    const config = JSON.parse(
        fs.readFileSync('/etc/mywebapp/config.json', 'utf-8')
    );
    host = config.db.host
    port = config.db.port
    user = config.db.user
    password = config.db.password
    name = config.db.name
}

const pool = new Pool({
    host: host,
    port: port,
    user: user,
    password: password,
    database: name,
});

export default pool

