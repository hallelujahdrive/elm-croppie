import Croppie, { CropType, CroppieOptions, ResultOptions } from "croppie";

export default class ElmCroppie extends HTMLElement {
    static croppies_: Map<String, ElmCroppie> = new Map();

    croppie_: Croppie | null;
    options_: CroppieOptions;
    resultOptions_: ResultOptions;

    static port (data: any) {
        const croppie = ElmCroppie.croppies_.get(data.id);
        if (croppie) {
            switch (data.method) {
                case "get":
                    croppie.get();
                case "bind":
                    croppie.bind(data.value);
                    break;
                case "result":
                    croppie.result(data.value);
                    break;
                case "rotate":
                    croppie.rotate(data.value);
                    break;
                case "setZoom":
                    croppie.setZoom(data.value);
                    break;
            }
        }
    }

    set options (options: CroppieOptions) {
        this.options_ = options;
    }

    set src (src: string) {
        if (this.croppie_) {
            this.croppie_.bind({url: src});
        }
    }

    constructor () {
        super();
        this.croppie_ = null;
        this.options_ = new Object;
        this.resultOptions_ = new Object;
    }

    connectedCallback () {
        const id = this.getAttribute("id");
        if (id) {
            this.croppie_ = new Croppie (this, this.options_);
            ElmCroppie.croppies_.set(id, this);
        }
    }

    disconnectedCallback () {
        if (this.croppie_) {
            this.croppie_.destroy;
        }
    }

    get () {
        if (this.croppie_) {
            const cropData = this.croppie_.get();
            this.dispatchEvent(new CustomEvent("get", {detail: cropData}));
        }
    }

    bind (options: any) {
        if (this.croppie_) {
            this.croppie_.bind(options);
        }
    }

    result (options: any) {
        if (this.croppie_) {
            this.croppie_.result(
                options
            ).then((res: string | HTMLElement) => {
                let type = "canvas"
                let value;
                if ("type" in options) {
                    type = options.type;
                }
                switch (options.type) {
                    case "html":
                        value = (res as HTMLElement).outerHTML;
                        break;
                    
                    default:
                        value = res;
                        break;

                }
                const obj = {
                    detail: {
                        type: type,
                        value: value
                    }
                }
                console.log(res);
                this.dispatchEvent(new CustomEvent ("result", obj));
            });
        }
    }

    rotate (degrees: 90 | 180 | 270 | -90 | -180 | -270 ) {
        if (this.croppie_) {
            this.croppie_.rotate(degrees);
        }
    }

    setZoom (zoom: number) {
        if (this.croppie_) {
            this.croppie_.setZoom(zoom);
        }
    }
}

customElements.define("elm-croppie", ElmCroppie);