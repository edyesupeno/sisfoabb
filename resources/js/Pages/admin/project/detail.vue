<script>
export default {
    layout: AppLayout
}
</script>
<script setup>
import axios from "axios";
import { notify } from "notiwind";
import { object, string } from "vue-types";
import { Head } from "@inertiajs/inertia-vue3";
import { ref, onMounted, reactive } from "vue";
import AppLayout from '@/layouts/apps.vue';
import VButton from '@/components/VButton/index.vue';
import debounce from "@/composables/debounce"
import VAlert from '@/components/VAlert/index.vue';
import VDropdownEditMenu from '@/components/VDropdownEditMenu/index.vue';
import VDataTable from '@/components/VDataTable/index.vue';
import VPagination from '@/components/VPagination/index.vue'
import VBreadcrumb from '@/components/VBreadcrumb/index.vue';
import VLoading from '@/components/VLoading/index.vue';
import VEmpty from '@/components/src/icons/VEmpty.vue';
import VBadge from '@/components/VBadge/index.vue';
import VDetail from '@/components/src/icons/VDetail.vue';
import VTrash from '@/components/src/icons/VTrash.vue';
import VEdit from '@/components/src/icons/VEdit.vue';
import VModalForm from './ModalForm.vue';
import AddModal from './AddModal.vue';


const query = ref([])
const breadcrumb = [
    {
        name: "Dashboard",
        active: false,
        to: route('dashboard.index')
    },
    {
        name: "Project",
        active: true,
        to: route('project.index')
    }
]
const pagination = ref({
    count: '',
    current_page: 1,
    per_page: '',
    total: 0,
    total_pages: 1
})
const closeAlert = () => {
    itemSelected.value = ref({})
    openAlert.value = false
}
const handleAddModalForm = () => {
    updateAction.value = false
    openModalFormtambah.value = true
}
const itemSelected = ref({})
const employdata = ref([])
const openModalForm = ref(false)
const openModalFormtambah = ref(false)
const heads = ["#", "Nama Project", "Pimpinan / Manager", "Alamat", "Status", "Aksi"]
const isLoading = ref(true)
const updateAction = ref(false)
const openAlert = ref(false)
const props = defineProps({
    title: string(),
    additional: object(),
})
const alertData = reactive({
    headerLabel: '',
    contentLabel: '',
    closeLabel: '',
    submitLabel: '',
})
const alertDelete = (data) => {
    itemSelected.value = data
    openAlert.value = true
    alertData.headerLabel = 'Are you sure to delete this?'
    alertData.contentLabel = "You won't be able to revert this!"
    alertData.closeLabel = 'Cancel'
    alertData.submitLabel = 'Delete'
}

const deleteHandle = async () => {
    axios.delete(route('settings.company.branch.delete', { 'id': itemSelected.value.id })
    ).then((res) => {
        notify({
            type: "success",
            group: "top",
            text: res.data.meta.message
        }, 2500)
        openAlert.value = false
        isLoading.value = true
        getData(pagination.value.current_page)
    }).catch((res) => {
        notify({
            type: "error",
            group: "top",
            text: res.response.data.message
        }, 2500)
    })
};
const handleEditModalForm = (data) => {
    updateAction.value = true
    itemSelected.value = data
    openModalFormtambah.value = true
}

const getData = debounce(async (page) => {
    axios.get(route('project.getdata'), {
        params: {
            page: page
        }
    }).then((res) => {
        console.log(res.data.data);
        query.value = res.data.data
        pagination.value = res
    }).catch((res) => {
        notify({
            type: "error",
            group: "top",
            text: res.response.data.message
        }, 2500)
    }).finally(() => isLoading.value = false)
}, 500);



const nextPaginate = () => {
    pagination.value.current_page += 1
    isLoading.value = true
    getData(pagination.value.current_page)
}

const previousPaginate = () => {
    pagination.value.current_page -= 1
    isLoading.value = true
    getData(pagination.value.current_page)
}

const handleDetailEmployee = (data) => {
    itemSelected.value = data
    openModalForm.value = true
}

const successSubmit = () => {
    isLoading.value = true
    getData(pagination.value.current_page)
}

const closeModalForm = () => {
    itemSelected.value = ref({})
    openModalForm.value = false
}
const closeModalFormtambah = () => {
    itemSelected.value = ref({})
    openModalFormtambah.value = false
}

const getStatusValue = (value) => {
    if (value === 'aas') {
        return 'warning';
    } else if (value === 'aktif') {
        return 'primary';
    } else if (value === 'tidak aktif') {
        return 'danger';
    } else {
        return 'primary';
    }
}

onMounted(() => {
    // getData(1);
});
</script>

<template>
    <Head :title="props.title" />
    <VBreadcrumb :routes="breadcrumb" />
    <div class="mb-4 sm:mb-6 flex justify-between items-center">
        <h1 class="text-2xl md:text-3xl text-slate-800 font-bold">Data Project</h1>
        <VButton label="Tambah Project Baru" type="primary" @click="handleAddModalForm" class="mt-auto" />
    </div>
    <div class="bg-white shadow-lg rounded-sm border border-slate-200" :class="isLoading && 'min-h-[40vh] sm:min-h-[50vh]'">
        <header class="block justify-between items-center sm:flex py-6 px-4">
            <h2 class="font-semibold text-slate-800">
                List Tabel Detail <span class="text-slate-400 !font-medium ml">{{ pagination.total }}</span>
            </h2>
        </header>

        <VDataTable :heads="heads" :isLoading="isLoading">
            <tr v-if="isLoading">
                <td class="h-[100%] overflow-hidden my-2" :colspan="heads.length">
                    <VLoading />
                </td>
            </tr>
            <tr v-else-if="query.length === 0 && !isLoading">
                <td class="overflow-hidden my-2" :colspan="heads.length">
                    <div class="flex items-center flex-col w-full my-32">
                        <VEmpty />
                        <div class="mt-9 text-slate-500 text-xl md:text-xl font-medium">Result not found.</div>
                    </div>
                </td>
            </tr>
            <tr v-for="(data, index) in query" :key="index" v-else>
                <td class="px-4 whitespace-nowrap h-16"> {{ data.id }} </td>
                <td class="px-4 whitespace-nowrap h-16"> {{ data.name }} </td>
                <td class="px-4 whitespace-nowrap h-16"> {{ data.nameuser }} </td>
                <td class="px-4 whitespace-nowrap h-16"> {{ data.city }} </td>
                <td class="px-4 whitespace-nowrap h-16 capitalize">
                    <VBadge :text="data.status" :color="getStatusValue(data.status)" size="sm" />
                </td>
                <!-- <td class="px-4 whitespace-nowrap h-16"> {{ data.created_by }} </td>
        <td class="px-4 whitespace-nowrap h-16"> {{ data.created_at }} </td>
        <td class="px-4 whitespace-nowrap h-16"> {{ data.branch }} </td> -->
                <td class="px-4 h-16 text-right  grid grid-cols-3 gap-2 content-center">
                    <VDetail class="cursor-pointer hover:bg-slate" color="3e403e" @click="handleDetailEmployee(data)" />
                    <VTrash class="cursor-pointer hover:bg-slate" color="3e403e" @click="alertDelete(data)" />
                    <VEdit class="cursor-pointer hover:bg-slate" color="3e403e" @click="handleEditModalForm(data)" />


                </td>
            </tr>
        </VDataTable>
        <div class="px-4 py-6">
            <VPagination :pagination="pagination" @next="nextPaginate" @previous="previousPaginate" />
        </div>
    </div>
    <AddModal :data="itemSelected" :update-action="updateAction" :open-dialog="openModalFormtambah"
        @close="closeModalFormtambah" @successSubmit="successSubmit" :additional="additional" :branch="filterBranchValue"
        :shiftList="shiftLists" />
    <VAlert :open-dialog="openAlert" @closeAlert="closeAlert" @submitAlert="deleteHandle" type="danger"
        :headerLabel="alertData.headerLabel" :content-label="alertData.contentLabel" :close-label="alertData.closeLabel"
        :submit-label="alertData.submitLabel" />
</template>