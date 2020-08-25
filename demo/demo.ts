import Elm from "./src/Main.elm";
import SweetAlert from "sweetalert";

import ElmCroppie from "elm-croppie";

const app = Elm.Main.init ({
    node: document.getElementById("elm")!
});

app.ports.croppie.subscribe ((data) => {
    ElmCroppie.port(data);
});

app.ports.sweetAlert.subscribe((src) => {
    SweetAlert({
        title: "",
        content: {
            element: "img",
            attributes: {
                src: src
            }
        }
    });

    requestAnimationFrame (() => {
        const swal = document.querySelector<HTMLElement>(".swal-modal");
        if (swal) {
            const top = -1 * (parseInt(swal.style.height) / 2);
            const left = -1 * (parseInt(swal.style.width) / 2);
            swal.style.margin = top + "px 0 0 " + left + "px";
        }
    });
});