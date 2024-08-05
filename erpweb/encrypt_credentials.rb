require 'rails/all'

Rails.application.credentials.write(
    secret_key_base: 'c28896cbf01654b67f7cc564f9d22065d507a2c34664a1684bc7c1d6e6dc35270f66ce8b33d8355324c810f61503febd6739ba15396f970b814c4ce1ab6e09a2',
  devise: {
    jwt_secret_key: '40081508cad0c366f737d23f74fd6a6a8ccb2091296966ff1bf2cb88714537c03d9395be08be1373d72bf4349edc60487d0c304fe6791ef5ef751634971ee58d'
  }
)