export namespace Elm {
    namespace Main {
        interface App {
            ports: Ports;
        }
  
        interface Args {
           node: HTMLElement;
        }

        interface Ports {
            croppie: Subscribe<String>;
            sweetAlert: Subscribe<String>;
        }
  
        interface Subscribe<T> {
            subscribe(callback: (value: T) => any): void;
        }
  
        interface Send<T> {
            send(value: T): void;
        }

        function init(args: Args): App;
    }
}

export default Elm;