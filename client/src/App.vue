<template>
    <div id="app">
        <v-container grid-list text-center>
            <v-layout justify-center column fill-height>
                <v-flex xs12 class="item">
                    <v-card color="#F9F9F9">
                        <v-list-item>
                            <v-list-tile-title> Tweets Mais Relevantes</v-list-tile-title>
                        </v-list-item>
                        <v-card-text>
                            <v-simple-table dense>
                                <thead>
                                    <tr>
                                        <th class="text-left">Screen Name</th>
                                        <th class="text-left">Followers Count</th>
                                        <th class="text-left">Retweet Count</th>
                                        <th class="text-left">Favorite Count</th>
                                        <th class="text-left">Text</th>
                                        <th class="text-left">Data de Criação</th>
                                        <th class="text-left">Profile Link</th>
                                        <th class="text-left">Link</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in tweets" :key="item.screen_name">
                                        <td>{{ item.screen_name }}</td>
                                        <td>{{ item.followers_count }}</td>
                                        <td>{{ item.retweet_count }}</td>
                                        <td>{{ item.favorite_count }}</td>
                                        <td>{{ item.text }}</td>
                                        <td>{{ item.created_at }}</td>
                                        <td><a href="#">{{ item.profile_link }}</a></td>
                                        <td><a target="_blank" href="#">{{ item.link }}</a></td>
                                    </tr>
                                </tbody>
                            </v-simple-table>
                        </v-card-text>
                    </v-card>
                </v-flex>
                <v-flex xs12 class="item">
                    <v-card color="#F9F9F9">
                        <v-list-item>
                            <v-list-tile-title> Usuários Que Mais Mencionaram a @Locaweb</v-list-tile-title>
                        </v-list-item>
                        <v-card-text>
                            <v-simple-table dense>
                                <thead>
                                    <tr>
                                        <th class="text-left">Screen Name</th>
                                        <th class="text-left">Followers Count</th>
                                        <th class="text-left">Retweet Count</th>
                                        <th class="text-left">Favorite Count</th>
                                        <th class="text-left">Text</th>
                                        <th class="text-left">Data de Criação</th>
                                        <th class="text-left">Profile Link</th>
                                        <th class="text-left">Link</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in users" :key="item.screen_name">
                                        <td>{{ item.screen_name }}</td>
                                        <td>{{ item.followers_count }}</td>
                                        <td>{{ item.retweet_count }}</td>
                                        <td>{{ item.favorite_count }}</td>
                                        <td>{{ item.text }}</td>
                                        <td>{{ item.created_at }}</td>
                                        <td><a href="#">{{ item.profile_link }}</a></td>
                                        <td><a target="_blank" :href="item.link">{{ item.link }}</a></td>
                                    </tr>
                                </tbody>
                            </v-simple-table>
                        </v-card-text>
                    </v-card>
                </v-flex>
            </v-layout>
        </v-container>
        <v-overlay :value="overlay">
            <v-progress-circular indeterminate size="64"></v-progress-circular>
        </v-overlay>
        <div class="text-center">
            <v-dialog v-model="dialog" width="500">
                <v-card>
                    <v-card-text>
                        Houve um problema ao acessar a api com os tweets! Sentimos muito. Tente novamente mais tarde.
                    </v-card-text>

                    <v-divider></v-divider>

                    <v-card-actions>
                        <v-spacer></v-spacer>
                        <v-btn color="primary" text @click="dialog = false">
                            Ok!
                        </v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>
        </div>
    </div>
</template>

<script>

    const axios = require('axios');

    export default {
        name: 'app',
        data() {
            return {
                tweets: [],
                users: [],
                logged: false,
                token: '',
                instance: '',
                loginBody: '',
                clientHeaders: '',
                overlay: true,
                dialog: false,
            }
        },
        watch: {
            // sempre que o valor de logged mudar, essa função será executada
            logged: function () {
                let headers = {
                    'Authorization': localStorage.getItem('token_type') + ' ' + localStorage.getItem('access_token')
                };

                this.getMostRelevant(headers);
                this.getMostMentions(headers)
            },
            overlay (val) {
                val && setTimeout(() => {
                    this.overlay = false
                }, 3000)
            },
        },
        methods: {

            login: function () {
                this.instance
                    .post('oauth/token', this.loginBody)
                    .then((response) => {
                        this.logged = !!(response.data.access_token);
                        if (this.logged) {
                            localStorage.setItem('logged', true);
                            localStorage.setItem('token_type', response.data.token_type);
                            localStorage.setItem('expires_in', response.data.expires_in);
                            localStorage.setItem('access_token', response.data.access_token);
                            localStorage.setItem('refresh_token', response.data.refresh_token)
                        }
                    })
                    .catch(() => {
                        this.overlay = false;
                        this.dialog = true;
                    });
            },

            getMostRelevant: function (headers) {
                this.instance
                    .get('api/most_relevant', { headers })
                    .then(response => (this.tweets = response.data))
                    .catch(() => {
                        this.overlay = false;
                        this.dialog = true;
                    })
            },

            getMostMentions: function (headers) {
                this.instance
                    .get('api/most_mentions', {headers})
                    .then(response => (
                            this.users = response.data.map(function (item) {
                                return item[Object.keys(item)[0]][0]
                            })
                        )
                    )
                    .catch(() => {
                        this.overlay = false;
                        this.dialog = true;
                    })
                    .finally(() => this.overlay = false)
            }
        },
        created: function() {

            this.loginBody = {
                "grant_type": process.env.VUE_APP_API_GRANT_TYPE,
                "client_id": process.env.VUE_APP_API_CLIENT_ID,
                "client_secret": process.env.VUE_APP_API_CLIENT_SECRET,
                "username": process.env.VUE_APP_API_USERNAME,
                "password": process.env.VUE_APP_API_PASSWORD,
                "scope": process.env.VUE_APP_API_SCOPE
            };

            this.instance = axios.create({
                baseURL: process.env.VUE_APP_API_HOST,
                headers: {
                    'Accept': 'application/json'
                }
            });

            this.login()
        }
    }
</script>

<style>
    #app {
        font-family: 'Avenir', Helvetica, Arial, sans-serif;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
        text-align: center;
        color: #2c3e50;
        margin-top: 60px;
    }
    .item {
        margin-bottom: 40px;
    }
</style>
