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

const employee_list = ref([])
const employee_list_id = ref([])
const group_list = ref([])
const typeOptions = ref(['Employee', 'Group'])
const jenisProject = ref(['Project', 'Office'])

onMounted(() => {
    getDataemployee();
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
    employeeSelectHandle.value ? employeeSelectHandle.value.clearSelected() : ''
    groupSelectHandle.value ? groupSelectHandle.value.clearSelected() : ''

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
        form.value.date = [new Date(props.data.tanggal), new Date(props.data.tanggal_akhir)]

        form.value.managera = props.data.nameuser

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
    for (let i = 0; i < employee_list.value.length; i++) {
        if (employee_list.value[i] == form.value.managera) {
            //set form value manager to string
            form.value.manager = employee_list_id.value[i]
        }
    }



    form.value.timezone = 'Asia/Jakarta';
    form.value.npwp_list_id = '1';
    isLoading.value = true
    axios.put(route('settings.company.branch.update', { 'id': props.data.id }), form.value)
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

const createData = async () => {
    //for employee_list  with for
    for (let i = 0; i < employee_list.value.length; i++) {
        if (employee_list.value[i] == form.value.managera) {
            //set form value manager to string
            form.value.manager = employee_list_id.value[i]
        }
    }



    form.value.timezone = 'Asia/Jakarta';
    form.value.npwp_list_id = '1';
    isLoading.value = true
    axios.post(route('settings.company.branch.create'), form.value)
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
    <VDialog :showModal="openDialog" :title="updateAction ? 'Update Employee Group' : 'Generate New Project'"
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
        <template v-slot:content>
            <div class="grid grid-cols-2 gap-3">

                <VInput placeholder="Insert Name" label="Name Project" :required="true" v-model="form.name"
                    :errorMessage="formError.name" @update:modelValue="formError.name = ''" />
                <div v-if="!isLoading">
                    <VSelect v-if="!isLoading" placeholder="Pilih Manager / Pimpinan" :required="true"
                        v-model="form.managera" :options="employee_list" label="manager" :errorMessage="formError.managera"
                        ref="typeSelectHandle" />
                </div>

                <VSelect placeholder="Insert Jenis" :required="true" v-model="form.type" :options="jenisProject"
                    label="Jenis Project" :errorMessage="formError.type" ref="typeSelectHandle"
                    @update:modelValue="handleType" />



                <VInput placeholder="+62xxxxx" label="No Hp" :required="true" v-model="form.nohp"
                    :errorMessage="formError.nohp" @update:modelValue="formError.nohp = ''" />

                <VSelect v-if="!isLoading" placeholder="Insert Status" :required="true" v-model="form.status"
                    :options="['Aktif', 'Tidak Aktif']" label="Status" :errorMessage="formError.status"
                    ref="typeSelectHandle" />

                <VInput placeholder="Alamat" label="Insert Alamat" :required="true" v-model="form.address"
                    :errorMessage="formError.address" @update:modelValue="formError.address = ''" />

                <VInput placeholder="City" label="Insert City" :required="true" v-model="form.city"
                    :errorMessage="formError.city" @update:modelValue="formError.city = ''" />

                <VInput placeholder="State" label="Insert State" :required="true" v-model="form.state"
                    :errorMessage="formError.state" @update:modelValue="formError.state = ''" />
                <VInput placeholder="Zip Code" label="Zip Code" :required="true" v-model="form.zip_code"
                    :errorMessage="formError.zip_code" @update:modelValue="formError.zip_code = ''" />

                <VInput placeholder="Latitude" label="Latitude" :required="true" v-model="form.latitude"
                    :errorMessage="formError.latitude" @update:modelValue="formError.latitude = ''" />

                <VInput placeholder="Longtitude" label="Longtitude" :required="true" v-model="form.longitude"
                    :errorMessage="formError.longitude" @update:modelValue="formError.longitude = ''" />

                <VInput placeholder="Radius" label="Radius" :required="true" v-model="form.radius"
                    :errorMessage="formError.radius" @update:modelValue="formError.radius = ''" />




                <div class="col-span-2">
                    <label class="block text-sm font-medium text-slate-600 mb-1">
                        Date Range<span class="text-rose-500">*</span>
                    </label>
                    <Datepicker v-model="form.date" @update:modelValue="handleDateRange" range :partial-range="false"
                        :enableTimePicker="false" position="left" :clearable="false" format="dd MMMM yyyy"
                        previewFormat="dd MMMM yyyy" placeholder="Select Date Range"
                        :class="{ 'date_error': formError.tanggal }" />
                    <div class="text-xs" :class="[{
                        'text-rose-500': formError.tanggal,
                    }]" v-if="formError.tanggal">
                        {{ formError.tanggal }}
                    </div>
                </div>



            </div>



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