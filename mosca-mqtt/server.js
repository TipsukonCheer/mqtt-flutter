let mosca = require('mosca');

let setting = {
    port : 1883,
    host : 'localhost'
}

let server = mosca.Server(setting);

server.on('ready',function(){
    console.log('Mosca server is ready')
});

server.authenticate = function(client,username,password,callback){
    console.log('authen');
    console.log('username'+username)
    callback(null,(username=='test'&&password=='test'));
    console.log(client.id+'had been authen')
};

server.on('clientConnected',function(client){
    console.log('client + : '+client.id+' has connected');
});

server.on('clientDisconnected',function(client){
    console.log('client + : '+client.id+' has disconnected');
});

server.on('clientDisconnecting',function(client){
    console.log('client + : '+client.id+' is disconnecting');
});

server.on('subscribed',function(topic,client){
    console.log('client : '+client.id+'is subscribing topic '+topic)
});

server.on('published',function(packet,client){
    console.log(packet);
    console.log('Published',packet.payload.toString())
    console.log(client)
    // console.log('client : '+client.id+'had published context topic: '+packet.topic +'/n' + 'with content :' + packet.payload)
});