// const functions = require('firebase-functions');
// const admin = require('firebase-admin');

// admin.initializeApp();

// exports.myFunction = functions.firestore
//   .document('chat/{message}')
//   .onCreate((snapshot, context) => {
//     return admin.messaging().sendToTopic('chat', {
//       notification: {
//         title: snapshot.data().username,
//         body: snapshot.data().text,
//         clickAction: 'FLUTTER_NOTIFICATION_CLICK',
//       },
//     });
//   });

const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()

exports.sendCommentsNotification = functions.firestore
  .document('comments/{commentsId}/userComments/{userCommentsId}')
  .onCreate((snap, context) => {
    console.log('----------------start function--------------------')

    const doc = snap.data()
    console.log(doc)

    const idFrom = doc.userId
    const idTo = doc.idTo
    const contentMessage = doc.content
    const docId = doc.docId

    // Get push token user to (receive)
    admin
      .firestore()
      .collection('users')
      .where('id', '==', idTo)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach((userTo) => {
          console.log(`Found user to: ${userTo.data().fullName}`)

         if (userTo.data().pushToken  
         &&  userTo.data().id !== idFrom ) {
            // Get info user from (sent)
            admin
              .firestore()
              .collection('users')
              .where('id', '==', idFrom)
              .get()
              .then(querySnapshot2 => {
                querySnapshot2.forEach(userFrom => {

                  console.log(`Found user from: ${userFrom.data().fullName}`)

                  const payload = {
                    notification: {
                      title: `You have a comment from "${userFrom.data().fullName}"`,
                      body: contentMessage,
                      badge: '1',
                     // icon:'https://firebasestorage.googleapis.com/v0/b/shop-90345.appspot.com/o/icon%2Fapp_icon.png?alt=media&token=0148983b-0a43-4f2d-86f0-205f244feb8d',
                      sound: 'default',  
                    //  image:`${userFrom.data().profileImage}`,
                    },
                    data: {
                      route:'DetailViewRoute',
                      docId:`${docId}`,
                      argument1:`${idFrom}`,
                      argument2:`${idTo}`,
                      click_action: 'FLUTTER_NOTIFICATION_CLICK'
                    }
                  }
                  // Let push to the target device
                  admin
                    .messaging()
                    .sendToDevice(userTo.data().pushToken, payload)
                    .then(response =>  console.log('Successfully sent comment:', response))
                    .catch(error => console.log('Error sending comment:', error))
                  })

                .catch(error => {
                    console.log('Error sending comment:', error)
                  })
                  return null

              })
              .catch(error => {
                console.log('Error sending comment:', error)
              })
              return null
         } else {
           console.log('Can not find pushToken target user')
         }
        })
          return null
      }) 
      .catch(error => {
        console.log('Error sending comment:', error)
      })  
    return null
  })



  exports.sendMessageNotification = functions.firestore
  .document('messages/{groupId1}/{groupId2}/{message}')
  .onCreate((snap, context) => {
    console.log('----------------start function--------------------')


    const doc = snap.data()
    console.log(doc)

    const idFrom = doc.idFrom
    const idTo = doc.idTo
    const contentMessage = doc.content

    // Get push token user to (receive)
    admin
      .firestore()
      .collection('users')
      .where('id', '==', idTo)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach((userTo) => {
          console.log(`Found user to: ${userTo.data().fullName}`)

         if (userTo.data().pushToken  
         && userTo.data().id !== idFrom 
         && userTo.data().chattingWith !== idFrom) {
            // Get info user from (sent)
            admin
              .firestore()
              .collection('users')
              .where('id', '==', idFrom)
              .get()
              .then(querySnapshot2 => {
                querySnapshot2.forEach(userFrom => {

                  console.log(`Found user from: ${userFrom.data().fullName}`)
         
                  const payload = {
                    notification: {
                      title: `You have a message from "${userFrom.data().fullName}"`,
                      body: contentMessage,
                      badge: '1',
                     // icon:'https://firebasestorage.googleapis.com/v0/b/shop-90345.appspot.com/o/icon%2Fapp_icon.png?alt=media&token=0148983b-0a43-4f2d-86f0-205f244feb8d',
                      sound: 'default',
                      //image:`${userFrom.data().profileImage}`,
                    },
                    data: {
                      route:'ChatViewRoute',
                      docId:'',
                      argument1:`${idFrom}`,
                      argument2:`${idTo}`,
                      click_action: 'FLUTTER_NOTIFICATION_CLICK'
                    }
                  }
                  // Let push to the target device
                  admin
                    .messaging()
                    .sendToDevice(userTo.data().pushToken, payload)
                    .then(response =>  console.log('Successfully sent message:', response))
                    .catch(error => console.log('Error sending message:', error))
                  })

                .catch(error => {
                    console.log('Error sending message:', error)
                  })
                  return null

              })
              .catch(error => {
                console.log('Error sending message:', error)
              })
              return null
         } else {
           console.log('Can not find pushToken target user')
         }
        })
          return null
      }) 
      .catch(error => {
        console.log('Error sending message:', error)
      })  
    return null
  })
