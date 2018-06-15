"use strict";

const admin = require('firebase-admin');

const functions = require('firebase-functions');

admin.initializeApp(functions.config().firebase);
const db = admin.firestore();


exports.subMenuQuery = functions.https.onRequest((request, response) => {


    var currentSubCategory = '';
    var items = new Array();
    var options = new Array();
    var jsonResult = new Array();
    var query = db.collection(request.body.collection).where('category', '==', request.body.category)
        .orderBy('subcategory').get()
        .then(snapshot => {
            snapshot.forEach(snapshot => {
                // console.log('sub', currentSubCategory);
                if (snapshot.get('subcategory') !== currentSubCategory && currentSubCategory !== '') {
                    jsonResult.push({
                        subCategory: currentSubCategory,
                        items: items || null,
                    });
                    items = [];
                }
                currentSubCategory = snapshot.get('subcategory');
                
                options.push({
                    size_one: snapshot.get('size-one'),
                    milk_one: snapshot.get('milk-one'),
                    eggtype_one: snapshot.get('eggtype-one'),
                    pancaketype_one: snapshot.get('pancaketype-one'),
                    topping_many: snapshot.get('topping-many'),
                    dressing_one: snapshot.get('dressing-one'),
                    choice_one: snapshot.get('choice-one'),
                    flavor_one: snapshot.get('flavor-one'),
                });
                
                    items.push({
                        name: snapshot.get('name'),
                        description: snapshot.get('description'),
                        options: options,
                        choices: ['empty'],
                        specialInstructions: '',
                        docRef: '',
                        url: snapshot.get('url') || null,
                    });
                options = [];
                 
                // console.log('jsonResults', JSON.stringify(jsonResult));
            });
        jsonResult.push({
            subCategory: currentSubCategory,
            items: items || null,
        });
        response.send(jsonResult);
        return;
        }).catch(err => {
            response.send(err);
        });
});




exports.featuredQuery = functions.https.onRequest((request, response) => {
   
    var currentSubCategory = '';
    var items = new Array();
    var options = new Array();
    var query = db.collection(request.body.collection).get()
        .then(snapshot => {
            snapshot.forEach(snapshot => {
               
                 if (snapshot.get('featured') === 'true') {
                    console.log('In here');
                    options.push({
                    size_one: snapshot.get('size-one'),
                    milk_one: snapshot.get('milk-one'),
                    eggtype_one: snapshot.get('eggtype-one'),
                    pancaketype_one: snapshot.get('pancaketype-one'),
                    topping_many: snapshot.get('topping-many'),
                    dressing_one: snapshot.get('dressing-one'),
                    choice_one: snapshot.get('choice-one'),
                    flavor_one: snapshot.get('flavor-one'),
                    });
                    items.push({
                        name: snapshot.get('name'),
                        description: snapshot.get('description'),
                        options: options,
                        choices: ['empty'],
                        specialInstructions: '',
                        docRef: '',
                        url: snapshot.get('url') || null,
                    });
                }
                options = [];
            });
          
            response.send(items);
            return;
        }).catch(err => {
            response.send(err);
        });
});




exports.favoritesQuery = functions.https.onRequest((request, response) => {
   

    var items = new Array();
    var options = new Array();
    var query = db.collection('Favorites').where('uid', '==', request.body.uid).get()
        .then(snapshot => {
            snapshot.forEach(snapshot => {

                    options.push({
                    size_one: snapshot.get('size-one'),
                    milk_one: snapshot.get('milk-one'),
                    eggtype_one: snapshot.get('eggtype-one'),
                    pancaketype_one: snapshot.get('pancaketype-one'),
                    topping_many: snapshot.get('topping-many'),
                    dressing_one: snapshot.get('dressing-one'),
                    choice_one: snapshot.get('choice-one'),
                    flavor_one: snapshot.get('flavor-one'),
                    });
                    var choices= new Array();
                    if(snapshot.get('choices').isEmpty) choices = ['empty']
                        else choices = snapshot.get('choices');
                    items.push({
                        name: snapshot.get('name'),
                        description: snapshot.get('description'),
                        options: options,
                        choices: choices,
                        specialInstructions: snapshot.get('specialInstructions'),
                        docRef: snapshot.get('docRef'),
                        url: snapshot.get('url') || null,
                    });
              
                options = [];
            });
            console.log('Items:', items);
            response.send(items);
            return;
        }).catch(err => {
            response.send(err);
        });
});


exports.favoritesQuery = functions.https.onRequest((request, response) => {
   

    var items = new Array();
    var options = new Array();
    var query = db.collection('Favorites').where('uid', '==', request.body.uid).get()
        .then(snapshot => {
            snapshot.forEach(snapshot => {

                    options.push({
                    size_one: snapshot.get('size-one'),
                    milk_one: snapshot.get('milk-one'),
                    eggtype_one: snapshot.get('eggtype-one'),
                    pancaketype_one: snapshot.get('pancaketype-one'),
                    topping_many: snapshot.get('topping-many'),
                    dressing_one: snapshot.get('dressing-one'),
                    choice_one: snapshot.get('choice-one'),
                    flavor_one: snapshot.get('flavor-one'),
                    });
                    var choices= new Array();
                    if(snapshot.get('choices').isEmpty) choices = ['empty']
                        else choices = snapshot.get('choices');
                    items.push({
                        name: snapshot.get('name'),
                        description: snapshot.get('description'),
                        options: options,
                        choices: choices,
                        specialInstructions: snapshot.get('specialInstructions'),
                        docRef: snapshot.get('docRef'),
                        url: snapshot.get('url') || null,
                    });
              
                options = [];
            });
            console.log('Items:', items);
            response.send(items);
            return;
        }).catch(err => {
            response.send(err);
        });
});




exports.shoppingCartQuery = functions.https.onRequest((request, response) => {
   

    var items = new Array();
    var options = new Array();
    var query = db.collection('Carts').where('uid', '==', request.body.uid)
    .where('status', '==', 'Pending').get()
        .then(snapshot => {
            snapshot.forEach(snapshot => {

                    options.push({
                    size_one: snapshot.get('size-one'),
                    milk_one: snapshot.get('milk-one'),
                    eggtype_one: snapshot.get('eggtype-one'),
                    pancaketype_one: snapshot.get('pancaketype-one'),
                    topping_many: snapshot.get('topping-many'),
                    dressing_one: snapshot.get('dressing-one'),
                    choice_one: snapshot.get('choice-one'),
                    flavor_one: snapshot.get('flavor-one'),
                    });
                    var choices= new Array();
                    if(snapshot.get('choices').isEmpty) choices = ['empty']
                        else choices = snapshot.get('choices');
                    items.push({
                        name: snapshot.get('name'),
                        description: snapshot.get('description'),
                        options: options,
                        choices: choices,
                        specialInstructions: snapshot.get('specialInstructions'),
                        docRef: snapshot.get('docRef'),
                        url: snapshot.get('url') || null,
                    });
              
                options = [];
            });
            console.log('Items:', items);
            response.send(items);
            return;
        }).catch(err => {
            response.send(err);
        });
});