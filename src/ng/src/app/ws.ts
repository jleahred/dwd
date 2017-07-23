import { parse, } from 'ts-node';
import { Subject } from 'rxjs/Subject';
import { cfgtesting } from '../config';


let ws: WebSocket;

const _onMessage = new Subject<any>();
export const ws_onmessage = _onMessage.asObservable();



if (cfgtesting() === false) {

  ws = new WebSocket('ws://localhost:8081/');
  ws.onopen = (event: Event) => {
    console.log('Socket has been opened!');
  };
  ws.onmessage = (msg: MessageEvent) => {
    console.log(msg.data);
    // console.log(msg.data);
    _onMessage.next(JSON.parse(msg.data));
    // _onMessage.next(
    //   {
    //     key0: msg.data,
    //     key1: 'html',
    //     val: ['aaa', 'bbbb']
    //   },
    // );
  };
}






export function ws_send(topic: string, type: string, data: any) {
  if (cfgtesting()) {
    ws_send_testing(data);
  } else {
    ws.send(
      JSON.stringify({
        'topic': topic,
        'type': type,
        'data': JSON.stringify(data)
      })

    );
  }
}


function ws_send_testing(msg: any) {
  _onMessage.next(
    {
      key0: msg,
      key1: msg,
      val: ['aaa', 'bbbb']
    },
  );

  _onMessage.next(
    {
      key0: 'doc',
      key1: 'html',
      val: ['aaa', 'bbbb']
    },
  );
  _onMessage.next(
    {
      key0: 'doc',
      key1: 'adoc',
      val: ['cccc', 'dddd']
    },
  );
  _onMessage.next(
    {
      key0: 'script',
      key1: 'go',
      val: ['eeee', 'ffff']
    },
  );
}
