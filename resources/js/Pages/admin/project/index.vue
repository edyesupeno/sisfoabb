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
import { Link } from "@inertiajs/inertia-vue3";
import { data } from "autoprefixer";


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
const heads = ["#", "name Project", "Lead Manager", "Address", "Type", "Action"]
const isLoading = ref(true)
const isdetail = ref(false)
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
  isdetail.value = true;
}

const successSubmit = () => {
  isLoading.value = true
  isdetail.value = false;
  getData(pagination.value.current_page)
}

const closeModalForm = () => {
  itemSelected.value = ref({})
  openModalForm.value = false
}
const closeModalFormtambah = () => {

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
  getData(1);
});
</script>

<template >
  <component v-if="!isdetail">

    <Head :title="props.title" />
    <VBreadcrumb :routes="breadcrumb" />
    <div class="mb-4 sm:mb-6 flex justify-between items-center">
      <h1 class="text-2xl md:text-3xl text-slate-800 font-bold">Data Project</h1>

      <VButton label="Tambah Project Baru" type="primary" @click="handleAddModalForm" class="mt-auto" />
    </div>
    <div class="bg-white shadow-lg rounded-sm border border-slate-200"
      :class="isLoading && 'min-h-[40vh] sm:min-h-[50vh]'">
      <header class="block justify-between items-center sm:flex py-6 px-4">
        <h2 class="font-semibold text-slate-800">
          List Tabel Projects <span class="text-slate-400 !font-medium ml">{{ pagination.total }}</span>
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
  </component>


  <component v-if="isdetail">

    <Head :title="props.title" />
    <VBreadcrumb :routes="breadcrumb" />
    <div class="mb-4 sm:mb-6 flex justify-between items-center">
      <h1 class="text-2xl md:text-3xl text-slate-800 font-bold">Manage Project : {{ itemSelected.name }} </h1>

    </div>
    <div class="grid grid-cols-2 gap-4 py-7">
      <div class="bg-white shadow-lg rounded-sm border border-slate-200"
        :class="isLoading && 'min-h-[40vh] sm:min-h-[50vh]'">
        <header class="flex justify-between items-center  py-6 px-4">
          <h2 class="font-semibold text-slate-800">
            Project Information
          </h2>
          <VButton label="Edit" type="primary" @click="handleEditModalForm(itemSelected)" class="mt-auto">
            <VEdit class="cursor-pointer hover:bg-slate" color="3e403e" @click="handleEditModalForm(itemSelected)" />
          </VButton>
        </header>
        <div class="flex justify-between items-center  px-4 w-3/5">
          <p class="w-48">Lead Manager</p>
          <p>:</p>
          <p class="w-48">{{ itemSelected.nameuser }}</p>
        </div>
        <div class="flex justify-between items-center  px-4 mt-1.5 w-3/5">
          <p class="w-48">Type</p>
          <p>:</p>
          <p class="w-48">{{ itemSelected.type }}</p>
        </div>
        <div class="flex justify-between items-center  px-4 mt-1.5 w-3/5">
          <p class="w-48">Phone number</p>
          <p>:</p>
          <p class="w-48">{{ itemSelected.nohp }}</p>
        </div>
        <div class="flex justify-between items-center  px-4 mt-1.5 w-3/5">
          <p class="w-48">Status</p>
          <p>:</p>
          <p class="w-48">
            <VBadge :text="itemSelected.status" :color="getStatusValue(itemSelected.status)" size="sm" />
          </p>
        </div>
        <div class="flex justify-between items-center  px-4 mt-1.5 w-3/5">
          <p class="w-48">Address</p>
          <p>:</p>
          <p class="w-48">{{ itemSelected.address }}</p>
        </div>
        <div class="flex justify-between items-center  px-4 mt-1.5 w-3/5">
          <p class="w-48">Start Project</p>
          <p>:</p>
          <p class="w-48">{{ itemSelected.tanggal }}</p>
        </div>
        <div class="flex justify-between items-center  px-4 mt-1.5 w-3/5">
          <p class="w-48">Done Project</p>
          <p>:</p>
          <p class="w-48">{{ itemSelected.tanggal_akhir }}</p>
        </div>
        <iframe class="mx-5 my-5 w-3/4" height="250" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"
          :src="'https://maps.google.com/maps?q=' + itemSelected.latitude + ',' + itemSelected.longitude + '&hl=id&z=14&amp;output=embed'">
        </iframe>

      </div>


      <div class="bg-white shadow-lg rounded-sm border border-slate-200"
        :class="isLoading && 'min-h-[40vh] sm:min-h-[50vh]'">
        <header class="mb-4 sm:mb-6 flex justify-between items-center sm:flex py-6 px-4">
          <h2 class="font-semibold text-slate-800">
            Kelola Project
          </h2>

        </header>
        <div class=" px-5">
          <div class="bg-white shadow-lg rounded-sm border border-slate-200  mt-1.5 flex justify-between">
            <div class="bg-grey shadow-lg rounded-sm h-28 w-44 content-center">
              <svg fill="white" class="px-10 py-2" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path
                  d="M13,9a1,1,0,0,0-1-1H3A1,1,0,0,0,2,9V22H13ZM6,20H4V18H6Zm0-4H4V14H6Zm0-4H4V10H6Zm5,8H8V18h3Zm0-4H8V14h3Zm0-4H8V10h3Zm3.5-6H6V3A1,1,0,0,1,7,2H17a1,1,0,0,1,1,1v7H15V6.5A.5.5,0,0,0,14.5,6ZM22,13v9H19.5V18h-2v4H15V13a1,1,0,0,1,1-1h5A1,1,0,0,1,22,13Z" />
              </svg>
            </div>
            <div class="  mt-1.5 w-4/6">
              <h4 class="w-48 font-semibold text-slate-800">Area & Pleton</h4>
              <div class="py-2"></div>
              <Link :href="'area/' + itemSelected.id">
              <div class="bg-grey shadow-lg rounded-sm h-3 w-44 flex justify-between items-center  py-6 px-5">
                <h4 class="w-20  text-slate-800 text-white">Detail</h4>

                <h4 class="text-slate-800 text-white">></h4>
              </div>
              </Link>

            </div>

          </div>

        </div>

        <div class=" px-5">
          <div class="bg-white shadow-lg rounded-sm border border-slate-200  mt-1.5 flex justify-between">
            <div class="bg-grey shadow-lg rounded-sm h-28 w-44 content-center">
              <svg fill="white" class="px-10 py-2" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <g>
                  <path fill="none" d="M0 0h24v24H0z" />
                  <path
                    d="M12.414 5H21a1 1 0 0 1 1 1v14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h7.414l2 2zM12 13a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5zm-4 5h8a4 4 0 1 0-8 0z" />
                </g>
              </svg>
            </div>
            <div class="  mt-1.5 w-4/6">
              <h4 class="w-48 font-semibold text-slate-800">Jabatan</h4>
              <div class="py-2"></div>
              <Link :href="'settings/employee/designation'">

              <div class="bg-grey shadow-lg rounded-sm h-3 w-44 flex justify-between items-center  py-6 px-5">
                <h4 class="w-20  text-slate-800 text-white">Detail</h4>

                <h4 class="text-slate-800 text-white">></h4>
              </div>
              </Link>
            </div>

          </div>

        </div>

        <div class=" px-5">
          <div class="bg-white shadow-lg rounded-sm border border-slate-200  mt-1.5 flex justify-between">
            <div class="bg-grey shadow-lg rounded-sm h-28 w-44 content-center">
              <svg fill="white" class="px-10 py-2" version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg"
                xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 448 448" xml:space="preserve">
                <g>
                  <g>
                    <path d="M408,288h-16v-40c0-22-18-40-40-40H232v-48h16c22,0,40-18,40-40V88c0-22-18-40-40-40h-48c-22,0-40,18-40,40v32
			c0,22,18,40,40,40h16v48H96c-22,0-40,18-40,40v40H40c-22,0-40,18-40,40v32c0,22,18,40,40,40h48c22,0,40-18,40-40v-32
			c0-22-18-40-40-40H72v-40c0-13.2,10.8-24,24-24h120v64h-16c-22,0-40,18-40,40v32c0,22,18,40,40,40h48c22,0,40-18,40-40v-32
			c0-22-18-40-40-40h-16v-64h120c13.2,0,24,10.8,24,24v40h-16c-22,0-40,18-40,40v32c0,22,18,40,40,40h48c22,0,40-18,40-40v-32
			C448,306,430,288,408,288z M88,304c13.2,0,24,10.8,24,24v32c0,13.2-10.8,24-24,24H40c-13.2,0-24-10.8-24-24v-32
			c0-13.2,10.8-24,24-24H88z M248,304c13.2,0,24,10.8,24,24v32c0,13.2-10.8,24-24,24h-48c-13.2,0-24-10.8-24-24v-32
			c0-13.2,10.8-24,24-24H248z M200,144c-13.2,0-24-10.8-24-24V88c0-13.2,10.8-24,24-24h48c13.2,0,24,10.8,24,24v32
			c0,13.2-10.8,24-24,24H200z M432,360c0,13.2-10.8,24-24,24h-48c-13.2,0-24-10.8-24-24v-32c0-13.2,10.8-24,24-24h48
			c13.2,0,24,10.8,24,24V360z" />
                  </g>
                </g>
              </svg>
            </div>
            <div class="  mt-1.5 w-4/6">
              <h4 class="w-48 font-semibold text-slate-800">Struktur Organisasi</h4>
              <div class="py-2"></div>
              <Link :href="'organisasi/' + itemSelected.id">
              <div class="bg-grey shadow-lg rounded-sm h-3 w-44 flex justify-between items-center  py-6 px-5">
                <h4 class="w-20  text-slate-800 text-white">Detail</h4>

                <h4 class="text-slate-800 text-white">></h4>
              </div>
              </Link>
            </div>

          </div>

        </div>

        <div class=" px-5">
          <div class="bg-white shadow-lg rounded-sm border border-slate-200  mt-1.5 flex justify-between">
            <div class="bg-grey shadow-lg rounded-sm h-28 w-44 content-center">
              <svg version="1.0" id="Layer_1" xmlns="http://www.w3.org/2000/svg"
                xmlns:xlink="http://www.w3.org/1999/xlink" fill="white" class="px-10 py-2" viewBox="0 0 64 64"
                xml:space="preserve">
                <g>
                  <path fill="white" d="M11,54h6c0.553,0,1-0.447,1-1v-5c0-0.553-0.447-1-1-1h-6c-0.553,0-1,0.447-1,1v5C10,53.553,10.447,54,11,54
		z M12,49h4v3h-4V49z" />
                  <path fill="white" d="M23,54h6c0.553,0,1-0.447,1-1v-5c0-0.553-0.447-1-1-1h-6c-0.553,0-1,0.447-1,1v5C22,53.553,22.447,54,23,54
		z M24,49h4v3h-4V49z" />
                  <path fill="white" d="M35,54h6c0.553,0,1-0.447,1-1v-5c0-0.553-0.447-1-1-1h-6c-0.553,0-1,0.447-1,1v5C34,53.553,34.447,54,35,54
		z M36,49h4v3h-4V49z" />
                  <path fill="white" d="M11,43h6c0.553,0,1-0.447,1-1v-5c0-0.553-0.447-1-1-1h-6c-0.553,0-1,0.447-1,1v5C10,42.553,10.447,43,11,43
		z M12,38h4v3h-4V38z" />
                  <path fill="white" d="M23,43h6c0.553,0,1-0.447,1-1v-5c0-0.553-0.447-1-1-1h-6c-0.553,0-1,0.447-1,1v5C22,42.553,22.447,43,23,43
		z M24,38h4v3h-4V38z" />
                  <path fill="white" d="M35,43h6c0.553,0,1-0.447,1-1v-5c0-0.553-0.447-1-1-1h-6c-0.553,0-1,0.447-1,1v5C34,42.553,34.447,43,35,43
		z M36,38h4v3h-4V38z" />
                  <path fill="white" d="M47,43h6c0.553,0,1-0.447,1-1v-5c0-0.553-0.447-1-1-1h-6c-0.553,0-1,0.447-1,1v5C46,42.553,46.447,43,47,43
		z M48,38h4v3h-4V38z" />
                  <path fill="white" d="M11,32h6c0.553,0,1-0.447,1-1v-5c0-0.553-0.447-1-1-1h-6c-0.553,0-1,0.447-1,1v5C10,31.553,10.447,32,11,32
		z M12,27h4v3h-4V27z" />
                  <path fill="white" d="M23,32h6c0.553,0,1-0.447,1-1v-5c0-0.553-0.447-1-1-1h-6c-0.553,0-1,0.447-1,1v5C22,31.553,22.447,32,23,32
		z M24,27h4v3h-4V27z" />
                  <path fill="white" d="M35,32h6c0.553,0,1-0.447,1-1v-5c0-0.553-0.447-1-1-1h-6c-0.553,0-1,0.447-1,1v5C34,31.553,34.447,32,35,32
		z M36,27h4v3h-4V27z" />
                  <path fill="white" d="M47,32h6c0.553,0,1-0.447,1-1v-5c0-0.553-0.447-1-1-1h-6c-0.553,0-1,0.447-1,1v5C46,31.553,46.447,32,47,32
		z M48,27h4v3h-4V27z" />
                  <path fill="white" d="M60,4h-7V3c0-1.657-1.343-3-3-3s-3,1.343-3,3v1H17V3c0-1.657-1.343-3-3-3s-3,1.343-3,3v1H4
		C1.789,4,0,5.789,0,8v52c0,2.211,1.789,4,4,4h56c2.211,0,4-1.789,4-4V8C64,5.789,62.211,4,60,4z M49,3c0-0.553,0.447-1,1-1
		s1,0.447,1,1v3v4c0,0.553-0.447,1-1,1s-1-0.447-1-1V6V3z M13,3c0-0.553,0.447-1,1-1s1,0.447,1,1v3v4c0,0.553-0.447,1-1,1
		s-1-0.447-1-1V6V3z M62,60c0,1.104-0.896,2-2,2H4c-1.104,0-2-0.896-2-2V17h60V60z M62,15H2V8c0-1.104,0.896-2,2-2h7v4
		c0,1.657,1.343,3,3,3s3-1.343,3-3V6h30v4c0,1.657,1.343,3,3,3s3-1.343,3-3V6h7c1.104,0,2,0.896,2,2V15z" />
                </g>
              </svg>
            </div>
            <div class="  mt-1.5 w-4/6">
              <h4 class="w-48 font-semibold text-slate-800">Schedule</h4>
              <div class="py-2"></div>
              <Link :href="'attendance/schedule'">
              <div class="bg-grey shadow-lg rounded-sm h-3 w-44 flex justify-between items-center  py-6 px-5">
                <h4 class="w-20  text-slate-800 text-white">Detail</h4>

                <h4 class="text-slate-800 text-white">></h4>
              </div>
              </Link>

            </div>

          </div>

        </div>
      </div>
    </div>
    <AddModal :data="itemSelected" :update-action="updateAction" :open-dialog="openModalFormtambah"
      @close="closeModalFormtambah" @successSubmit="successSubmit" :additional="additional" :branch="filterBranchValue"
      :shiftList="shiftLists" />
    <VAlert :open-dialog="openAlert" @closeAlert="closeAlert" @submitAlert="deleteHandle" type="danger"
      :headerLabel="alertData.headerLabel" :content-label="alertData.contentLabel" :close-label="alertData.closeLabel"
      :submit-label="alertData.submitLabel" />
  </component>
</template>