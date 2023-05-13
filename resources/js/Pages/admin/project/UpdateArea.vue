<script setup>
import axios from "axios";
import dayjs from "dayjs"
import { onMounted, ref } from "vue";
import { bool, object, any } from "vue-types";
import { notify } from "notiwind";
import VDialog from '@/components/VDialog/index.vue';
import VButton from '@/components/VButton/index.vue';
import VSelect from '@/components/VSelect/index.vue';
import VInput from '@/components/VInput/index.vue';
import debounce from "@/composables/debounce";

const props = defineProps({
    openDialog: bool(),
    updateAction: bool().def(false),
    data: object().def([]),
    additional: object().def({}),
    branch: any(),
    detail: bool().def(false),
    shiftList: object().def({})
})

const emit = defineEmits(['close', 'successSubmit'])

const isLoading = ref(false);
const formError = ref({})
const datakaryawan = []
const form = ref({})
const branchSelectHandle = ref()
const typeSelectHandle = ref()
const employeeSelectHandle = ref()
const groupSelectHandle = ref()
const isdetail = ref(false)
const employee_list = ref([])
const employee_list_id = ref([])
const group_list = ref([])
const typeOptions = ref(['Employee', 'Group'])
var jenisProject = ref([])
var pletonvar = ref([]);
var indexarea = ref([]);
var query = ref([])
var query2 = ref([])

onMounted(() => {
    getData();
});

const changeUser = () => {


    if (form.value.branch_id) {
        axios.get(route('attendance.schedule.getEmployeeByBranch', { 'branch_id': form.value.branch_id })
        ).then((res) => {
            employee_list.value = res.data
            console.log(employee_list.value)
        }).catch((err) => {
            console.log(err)
        })

        axios.get(route('attendance.schedule.getGroupByBranch', { 'branch_id': form.value.branch_id })
        ).then((res) => {
            group_list.value = res.data
        }).catch((err) => {
            console.log(err)
        })
    }

}
const getDataemployee = debounce(async (page) => {
    axios.get(route('project.getdataemploy'), {
        params: {
            page: page
        }
    }).then((res) => {
        //res data data karyawan

        //convert data karyawan to VSelect data
        res.data.forEach((item) => {
            //if admin no
            if (item.name != 'Admin') {
                employee_list.value.push(item.name)
                employee_list_id.value.push(item.id)

            }

        });
        if (props.updateAction) {



        }
    }).catch((res) => {
        notify({
            type: "error",
            group: "top",
            text: res
        }, 2500)
    }).finally(() => isLoading.value = false)
}, 500);

const handleType = () => {
    pletonvar.value = [];
    // for query.value
    for (let i = 0; i < query.value.length; i++) {
        //if query.value[i].nama same with from.are
        if (query.value[i].nama == form.value.area) {
            //for query.value[i].pleton
            for (let j = 0; j < query.value[i].pleton.length; j++) {
                //push query.value[i].pleton[j].nama to pletonvar.value
                pletonvar.value.push(query.value[i].pleton[j].nama)
            }
        }
    }
}

const handletypeto = async () => {
    jenisProject = ref([]);
    getDatashift();
}

const handleDateRange = () => {
    const dateStart = new Date(form.value.date[0].getFullYear(), form.value.date[0].getMonth(), form.value.date[0].getDate())
    const dateEnd = new Date(form.value.date[1].getFullYear(), form.value.date[1].getMonth(), form.value.date[1].getDate())

    form.value.tanggal = dayjs(dateStart).format('YYYY-MM-DD')
    form.value.tanggal_akhir = dayjs(dateEnd).format('YYYY-MM-DD')
}

const openForm = () => {
    if (props.updateAction) {

        form.value = Object.assign(form.value, props.data)
        form.value.pleton = props.data.pleton
        // form.value.name = props.data.nama
        // form.value.pleton = props.data.pleton[0].nama
        // form.value.pleton_id = props.data.pleton[0].id

    } else {

        form.value = ref({})
        form.value.branch_id = props.branch
        changeUser()
    }
}

const closeForm = () => {

    form.value = ref({})
    formError.value = ref({})
}


const submit = async () => {
    props.updateAction ? updateData() : createData()
}

const updateData = async () => {
    //for employee_list  with for
    const url = window.location.href;
    const lastSegment = url.split("/").pop();
    //add to from last segment
    form.value.id = props.data.id
    axios.post(route('organisasi.addOrganisasi'), form.value)
        .then((res) => {
            emit('close')
            emit('successSubmit')
            form.value = ref({})
            notify({
                type: "success",
                group: "top",
                text: res.data.meta.message
            }, 2500)
        }).catch((res) => {
            // Handle validation errors
            const result = res.response.data
            if (result.hasOwnProperty('errors')) {
                formError.value = ref({});
                Object.keys(result.errors).map((key) => {
                    formError.value[key] = result.errors[key].toString();
                });
            }
            console.log(res);
            notify({
                type: "error",
                group: "top",
                text: result.message
            }, 2500)
        }).finally(() => isLoading.value = false)
}

//get data employ
const getData = debounce(async (page) => {
    //get last of url
    const url = window.location.href;
    const lastSegment = url.split("/").pop();
    axios.get(route('project.getDataArea'), {
        params: {
            page: page,
            id: lastSegment
        }
    }).then((res) => {
        console.log(res.data.data);
        query.value = res.data.data

        //convert query to vselect
        for (let i = 0; i < query.value.length; i++) {

            employee_list.value.push(query.value[i].nama)
            employee_list_id.value.push(query.value[i].id)

        }
    }).catch((res) => {
        console.log(res);
        query.value = res.data


        for (let i = 0; i < query.length; i++) {
            console.log(query.value[i].nama);
            employee_list.value.push(query.value[i].nama)
            employee_list_id.value.push(query.value[i].id)
        }
    }).finally(() => isLoading.value = false)
}, 500);

const getDatashift = debounce(async (page) => {
    //get last of url
    const url = window.location.href;
    const lastSegment = url.split("/").pop();
    form.value.branch_id = lastSegment
    axios.post(route('organisasi.getDataShift'), form.value).then((res) => {
        console.log(res.data.data);
        query.value = res.data.data

        //convert query to vselect
        for (let i = 0; i < query.value.length; i++) {

            jenisProject.value.push(query.value[i].name)

        }
    }).catch((res) => {
        console.log(res);
        query.value = res.data


        // for (let i = 0; i < query.length; i++) {
        //     console.log(query.value[i].nama);
        //     employee_list.value.push(query.value[i].nama)
        //     employee_list_id.value.push(query.value[i].id)
        // }
    }).finally(() => isLoading.value = false)
}, 500);


const createData = async () => {
    const url = window.location.href;
    const lastSegment = url.split("/").pop();
    //add to from last segment
    form.value.id = lastSegment
    isLoading.value = true
    var urlpost = '';
    if (props.detail) {
        urlpost = route('area.addPleton')
        form.value.id = props.data.id
    } else {
        urlpost = route('area.addData')
    }
    axios.post(urlpost, form.value)
        .then((res) => {
            emit('close')
            emit('successSubmit')
            form.value = ref({})
            notify({
                type: "success",
                group: "top",
                text: res.data.meta.message
            }, 2500)
        }).catch((res) => {
            // Handle validation errors
            const result = res.response.data
            if (result.hasOwnProperty('errors')) {
                formError.value = ref({});
                Object.keys(result.errors).map((key) => {
                    formError.value[key] = result.errors[key].toString();
                });
            }
            console.log(res);
            notify({
                type: "error",
                group: "top",
                text: result.message
            }, 2500)
        }).finally(() => isLoading.value = false)
}
</script>



<template>
    <VDialog :showModal="openDialog"
        :title="updateAction ? 'Update Area And Schedule' : props.detail ? 'Generate Pleton' : 'Generate Area'"
        @opened="openForm" @closed="closeForm" size="xl">
        <template v-slot:close>
            <button class="text-slate-400 hover:text-slate-500" @click="$emit('close')">
                <div class="sr-only">Close</div>
                <svg class="w-4 h-4 fill-current">
                    <path
                        d="M7.95 6.536l4.242-4.243a1 1 0 111.415 1.414L9.364 7.95l4.243 4.242a1 1 0 11-1.415 1.415L7.95 9.364l-4.243 4.243a1 1 0 01-1.414-1.415L6.536 7.95 2.293 3.707a1 1 0 011.414-1.414L7.95 6.536z" />
                </svg>
            </button>
        </template>
        <template v-slot:content v-if="!isLoading">
            <VSelect placeholder="Insert Area" :required="true" v-model="form.area" :options="employee_list"
                label="Select Area" :errorMessage="formError.area" ref="typeSelectHandle" @update:modelValue="handleType" />
            <br>
            <VSelect placeholder="Insert Pleton" :required="true" v-model="form.pleton" :options="pletonvar"
                label="Select Pleton" :errorMessage="formError.pleton" ref="typeSelectHandle"
                @update:modelValue="handletypeto" />
            <br>
            <VSelect placeholder="Insert Schedule" :required="true" v-model="form.schedule" :options="jenisProject"
                label="Select Schedule" :errorMessage="formError.schedule" ref="typeSelectHandle"
                @update:modelValue="handleType" />


        </template>
        <template v-slot:footer>
            <div class="flex flex-wrap justify-end space-x-2">
                <VButton label="Cancel" type="default" @click="$emit('close')" />
                <VButton :is-loading="isLoading" :label="updateAction ? 'Update' : 'Create'" type="primary"
                    @click="submit" />
            </div>
        </template>
    </VDialog>
</template>

<style>
.dp__select {
    color: #4F8CF6 !important;
}

.date_error {
    --dp-border-color: #dc3545 !important;
}
</style>