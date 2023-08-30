<script>
export default {
    layout: AppLayout
}
</script>
<script setup>
import { Inertia } from '@inertiajs/inertia'
import { object, string } from "vue-types";
import { Head } from "@inertiajs/inertia-vue3";
import { ref, onMounted, watch } from "vue";
import AppLayout from '@/layouts/apps.vue';
import VBreadcrumb from '@/components/VBreadcrumb/index.vue';
import VButton from '@/components/VButton/index.vue';

import axios from "axios";
import dayjs from "dayjs";
import { notify } from "notiwind";
import debounce from "@/composables/debounce"
import VBack from '@/components/src/icons/VBack.vue'
import VSidebarSetting from '@/components/VSidebarSetting/index.vue';
import VDataTable from '@/components/VDataTable/index.vue';
import VPagination from '@/components/VPagination/index.vue'
import VFilter from '../../../employees/employee/attendanceLog/Filter.vue';
import VLoading from '@/components/VLoading/index.vue';
import VBadge from '@/components/VBadge/index.vue';
import VEmpty from '@/components/src/icons/VEmpty.vue';
import VPresent from '@/components/src/icons/VPresent.vue';
import VHoliday from '@/components/src/icons/VHoliday.vue';
import VLeave from '@/components/src/icons/VLeave.vue';
import VLate from '@/components/src/icons/VLate.vue';
import VAbsent from '@/components/src/icons/VAbsent.vue';
import VClockoutEarly from '@/components/src/icons/VClockoutEarly.vue';

const breadcrumb = [
    {
        name: "Dashboard",
        active: false,
        to: route('dashboard.index')
    },
    {
        name: "Payroll",
        active: false,
        to: route('payroll.run.index')
    },
    {
        name: "Payroll Employee",
        active: false,
        to: route('payroll.run.payrollemployee', { 'id': props.additional.payroll_employee.payroll_slip_id })
    },
    {
        name: "Payroll Slip",
        active: true,
        to: route('payroll.run.payrollemployee.detail', { 'id': props.additional.payroll_employee.id })
    },
]
const isLoading = ref(true)
const payrollLeftInformation = ref([])

const props = defineProps({
    title: string(),
    additional: object(),
})

const handleEditPage = () => {
    Inertia.visit(route('payroll.run.payrollemployee.edit', { 'id': props.additional.payroll_employee.id }));
}

const initData = () => {
    payrollLeftInformation.value = [
        {
            label: 'Employee Name',
            value: props.additional.payroll_employee.employee_detail.user_detail.name
        },
        {
            label: 'Employee External Id',
            value: props.additional.payroll_employee.employee_detail.employee_external_id
        },
        {
            label: 'Designation',
            value: props.additional.payroll_employee.employee_detail.designation_detail.name
        },
        {
            label: 'Phone Number',
            value: props.additional.payroll_employee.employee_detail.phone_number
        }
    ]
}

// Attendance
const pagination = ref({
    count: '',
    current_page: 1,
    per_page: '',
    total: 0,
    total_pages: 1
})
const attendanceOverview = ref([
    {
        label: 'Present',
        value: 0,
        work_hours: '00:00:00',
        type: 'present'
    },
    {
        label: 'Absent',
        value: 0,
        work_hours: null,
        type: 'absent'
    },
    {
        label: 'Late',
        value: 0,
        work_hours: '01:00:00',
        type: 'late'
    },
    {
        label: 'Clockout Early',
        value: 0,
        work_hours: '09:00:00',
        type: 'clockout_early'
    },
]);
const backActive = ref(false)
const query = ref([])
const searchFilter = ref("");
const filter = ref({})

const heads = ["Date", "Clock In", "Clock Out", "Work Hours", "Status"]
const isLoadingAttendance = ref(true)
const overviewLoading = ref(true)

const nextPaginate = () => {
    pagination.value.current_page += 1
    isLoadingAttendance.value = true
    getData(pagination.value.current_page)
}

const previousPaginate = () => {
    pagination.value.current_page -= 1
    isLoadingAttendance.value = true
    getData(pagination.value.current_page)
}

const searchHandle = (search) => {
    searchFilter.value = search
    isLoadingAttendance.value = true
    getData(1)
};

const applyFilter = (data) => {
    filter.value = data
    isLoadingAttendance.value = true
    getData(1)
}

const clearFilter = (data) => {
    filter.value = data
    isLoadingAttendance.value = true
    getData(1)
}

const getTypeStatus = (status) => {
    if (status === 'present') {
        return 'primary-solid';
    } else if(status === 'holiday'){
        return 'yellow-solid';
    } else if (status === 'leave') {
        return 'pink-solid';
    } else if (status === 'late') {
        return 'amber-solid';
    } else if (status === 'absent') {
        return 'red-solid';
    } else if (status === 'clockout_early') {
        return 'cyan-solid';
    } else {
        return 'primary';
    }
}

const getIconStatus = (status) => {
    if (status === 'present') {
        return VPresent;
    } else if (status === 'holiday') {
        return VHoliday;
    } else if (status === 'leave') {
        return VLeave;
    } else if (status === 'late') {
        return VLate;
    } else if (status === 'absent') {
        return VAbsent;
    } else if (status === 'clockout_early') {
        return VClockoutEarly;
    } else {
        return '';
    }
}

const getData = debounce(async (page) => {
    axios.get(route('employment.employee.attendance-log.getdata', { 'id': props.additional.payroll_employee.employee_id }), {
        params: {
            page: page,
            search: searchFilter.value,
            filter_date: [dayjs(props.additional.start_date).add(1, 'day').toISOString(), dayjs(props.additional.end_date).add(1, 'day').toISOString()],
            filter_status: filter.value.filter_status
        }
    }).then((res) => {
        query.value = res.data.data
        pagination.value = res.data.meta.pagination
    }).catch((res) => {
        notify({
            type: "error",
            group: "top",
            text: res.response.data.message
        }, 2500)
    }).finally(() => isLoadingAttendance.value = false)
}, 500);

const getAttendanceOverviewData = debounce(async (page) => {
    axios.get(route('employment.employee.attendance-log.getdataoverview', { 'id': props.additional.payroll_employee.employee_id }), {
        params: {
            page: page,
            filter_date: [dayjs(props.additional.start_date).add(1, 'day').toISOString(), dayjs(props.additional.end_date).add(1, 'day').toISOString()]
            // filter_date: ['2023-06-30T17:00:00.000Z', '2023-07-31T04:12:00.000Z']
        }
    }).then((res) => {
        let present = attendanceOverview.value.find(e => e.type === 'present')
        let absent = attendanceOverview.value.find(e => e.type === 'absent')
        let late = attendanceOverview.value.find(e => e.type === 'late')
        let clockout_early = attendanceOverview.value.find(e => e.type === 'clockout_early')

        present.value = res.data.data.total_present
        present.work_hours = res.data.data.present_work_hours
        absent.value = res.data.data.total_absent
        late.value = res.data.data.total_late
        late.work_hours = res.data.data.late_work_hours
        clockout_early.value = res.data.data.total_clockout_early,
        clockout_early.work_hours = res.data.data.clockout_early_work_hours
    }).catch((res) => {
        notify({
            type: "error",
            group: "top",
            text: res.response.data.message
        }, 2500)
    }).finally(() => overviewLoading.value = false)
}, 500);

// OverTime
const query2 = ref([])
const paginationOT = ref({
    count: '',
    current_page: 1,
    per_page: '',
    total: 0,
    total_pages: 1
})
const itemSelectedOT = ref({})
const openModalFormOT = ref(false)
const headsOT = ["Type", "Status", "Created By", "Created At", "Branch"]
const isLoadingOT = ref(true)
const isapprovalOT = ref(true)

const getData2 = debounce(async (page) => {
    axios.get(route('approval.getlembur'), {
        params: {
            page: page,
            employee_id: props.additional.user_id,
            filter_date: [dayjs(props.additional.start_date).add(1, 'day').toISOString(), dayjs(props.additional.end_date).add(1, 'day').toISOString()],
            // filter_date: ['2022-05-01T17:00:00.000Z', '2023-05-30T17:00:00.000Z']
        }
    }).then((res) => {
        query2.value = res.data.data
        console.log('TES', query2.value, res.data.data)
    }).catch((res) => {
        notify({
            type: "error",
            group: "top",
            text: res.response.data.message
        }, 2500)
    }).finally(() => isLoadingOT.value = false)
}, 500);

const nextPaginateOT = () => {
    paginationOT.value.current_page += 1
    isLoadingOT.value = true
    getData2(paginationOT.value.current_page)
}

const previousPaginateOT = () => {
    paginationOT.value.current_page -= 1
    isLoadingOT.value = true
    getData2(paginationOT.value.current_page)
}

//handle flip flop is approval
const handleIsApprovalOT = (i) => {
    isapprovalOT.value = i;

}

const handleDetailEmployeeOT = (data) => {
    itemSelectedOT.value = data
    openModalFormOT.value = true
}

const successSubmitOT = () => {
    isLoadingOT.value = true
    getData2(paginationOT.value.current_page)
}

const closeModalFormOT = () => {
    itemSelectedOT.value = ref({})
    openModalFormOT.value = false
    getData2();
}

const getStatusValueOT = (value) => {
    if (value === 'awaiting') {
        return 'warning';
    } else if (value === 'approved') {
        return 'success';
    } else if (value === 'rejected') {
        return 'danger';
    } else {
        return 'primary';
    }
}

watch(() => props.additional, (newValue, oldValue) => {
    if (newValue) {
        initData()
    }
});

onMounted(() => {
    initData()
    getAttendanceOverviewData()
    getData(1)
    getData2(1)
});

</script>

<template>
    <Head :title="props.title" />
    <VBreadcrumb :routes="breadcrumb" />
    <div class="mb-4 sm:mb-6 flex justify-between items-center">
        <h1 class="text-2xl md:text-3xl text-slate-800 font-bold">Payroll Slip</h1>
    </div>
    <div class="bg-white shadow-lg rounded-sm border border-slate-200 mb-8"
        :class="isLoading && 'min-h-[40vh] sm:min-h-[50vh]'">
        <header class="block justify-between items-center sm:flex py-6 px-4 border-b">
            <h2 class="font-bold text-slate-800">
                Payroll Slip for the Month of {{ additional.payroll_date }}
            </h2>
            <div class="mt-3 sm:mt-0 flex space-x-2 sm:justify-between justify-end">
                <VButton label="Edit Slip" type="primary" class="mt-auto" @click="handleEditPage"/>
            </div>
        </header>
        <div class="p-6">
            <div class="w-full text-center font-bold text-md bg-sky-100 p-2 rounded-md border border-sky-100">
                <div class="mb-2">
                    Salary Slip
                </div>
                <div>
                    Period : {{ additional.payroll_date }}
                </div>
            </div>
            <div class="grid grid-cols-2 gap-4 py-6 px-2">
                <div class="grid grid-cols-2 gap-4">
                    <div class="text-slate-600 font-bold text-md">
                        Employee Name
                    </div>
                    <div>
                        {{ additional.payroll_employee.employee_detail.user_detail.name }}
                    </div>
                    <div class="text-slate-600 font-bold text-md">
                        Employee External Id
                    </div>
                    <div>
                        {{ additional.payroll_employee.employee_detail.employee_external_id }}
                    </div>
                    <div class="text-slate-600 font-bold text-md">
                        Designation
                    </div>
                    <div>
                        {{ additional.payroll_employee.employee_detail.designation_detail.name }}
                    </div>
                    <div class="text-slate-600 font-bold text-md">
                        Phone Number
                    </div>
                    <div>
                        {{ additional.payroll_employee.employee_detail.phone_number }}
                    </div>
                </div>
               <div class="grid grid-cols-2 gap-4">
                    <div class="text-slate-600 font-bold text-md">
                        Branch Name
                    </div>
                    <div>
                        {{ additional.payroll_employee.employee_detail.branch_detail.name }}
                    </div>
                    <div class="text-slate-600 font-bold text-md">
                        Bank Name
                    </div>
                    <div>
                        {{ additional.payroll_employee.employee_detail.bank_name ?? '-' }}
                    </div>
                    <div class="text-slate-600 font-bold text-md">
                        Account Name
                    </div>
                    <div>
                        {{ additional.payroll_employee.employee_detail.account_name ?? '-' }}
                    </div>
                    <div class="text-slate-600 font-bold text-md">
                        Account Number
                    </div>
                    <div>
                        {{ additional.payroll_employee.employee_detail.account_number ?? '-' }}
                    </div>
                </div>
            </div>
            <div class="grid grid-cols-2 gap-4">
                <!-- Income -->
                <div>
                    <div class="bg-sky-100 text-center p-2 font-bold text-md rounded-md border border-sky-100 mb-2">Income</div>
                    <div class="px-2 space-y-2">
                        <div class="flex justify-between">
                            <div>
                                Base Salary
                            </div>
                            <div>
                                Rp{{ additional.base_salary }}
                            </div>
                        </div>
                        <div class="flex justify-between" v-for="(data, index) in additional.earning_components" :key="index">
                            <div>
                                {{ data.name }}
                                <span class="font-bold">
                                    <span v-if="data.pay_type == 'fix'">x {{ data.total_cross }}</span>
                                    <span v-else-if="data.pay_type == 'attendance'">x {{ data.total_cross }} Hari</span>
                                    <span v-else-if="data.pay_type == 'overtime_days'">x {{ data.total_cross }} Hari</span>
                                    <span v-else-if="data.pay_type == 'overtime_hours'">x {{ data.total_cross }} Jam</span>
                                </span>
                            </div>
                            <div>
                                Rp{{ data.amount }}
                            </div>
                        </div>
                        <div class="flex justify-between">
                            <div class="font-semibold">
                                Total Income
                            </div>
                            <div>
                                Rp{{ additional.total_earning }}
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Deduction -->
                <div>
                    <div class="bg-sky-100 text-center p-2 font-bold text-md rounded-md border border-sky-100 mb-2">Deduction</div>
                    <div class="px-2 space-y-2">
                        <div class="flex justify-between" v-for="(data, index) in additional.deduction_components" :key="index">
                            <div>
                                {{ data.name }}
                                <span v-if="index != 0" class="font-bold">
                                    <span v-if="data.pay_type == 'fix'">x {{ data.total_cross }}</span>
                                    <span v-else-if="data.pay_type == 'attendance'">x {{ data.total_cross }} Hari</span>
                                    <span v-else-if="data.pay_type == 'overtime_days'">x {{ data.total_cross }} Hari</span>
                                    <span v-else-if="data.pay_type == 'overtime_hours'">x {{ data.total_cross }} Jam</span>
                                </span>
                            </div>
                            <div>
                                Rp{{ data.amount }}
                            </div>
                        </div>
                        <div class="flex justify-between">
                            <div class="font-semibold">
                                Total Deduction
                            </div>
                            <div>
                                Rp{{ additional.total_deduction }}
                            </div>
                        </div>
                    </div>
                    <div class="bg-sky-100 p-2 font-semibold text-md rounded-md border border-sky-100 mt-2 flex justify-between">
                        <div class="ml-6">
                            Take Home Pay
                        </div>
                        <div>
                            Rp{{ additional.take_home_pay }}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Attendance -->
    <div class="bg-white shadow-lg rounded-sm mb-8">
        <div class="flex flex-col sm:flex-row md:-mr-px">
            <div class="grow">
                <div class="p-4">
                    <div class="flex justify-between">
                        <div class="font-semibold text-xl text-slate-800 mb-5">
                            Attendance Overview
                        </div>
                    </div>
                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                        <div class="rounded border py-4 pr-4 flex" v-for="(data, index) in attendanceOverview"
                            :key="index">
                            <div class="w-1.5 rounded-r mr-4" :class="{
                                'bg-blue-500': data.type === 'present',
                                'bg-red-500': data.type === 'absent',
                                'bg-amber-500': data.type === 'late',
                                'bg-cyan-600': data.type === 'clockout_early'
                            }"></div>
                            <div class="text-slate-800">
                                <div class="font-medium text-base">
                                    {{ data.label }}
                                </div>
                                <div v-if="overviewLoading" class="mt-1">
                                    <VLoading />
                                </div>
                                <div v-else>
                                    <div class="font-semibold text-3xl">
                                        {{ data.value }}
                                    </div>
                                    <div class="font-medium text-sm !text-slate-500" v-if="data.work_hours">
                                        {{ data.work_hours }}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Table  -->
                    <section>
                        <header class="block justify-between items-center sm:flex pt-8 pb-5">
                            <h2 class="font-semibold text-slate-800">
                                All Attendance Log <span class="text-slate-400 !font-medium ml">{{ pagination.total
                                }}</span>
                            </h2>
                            <div class="mt-3 sm:mt-0 flex space-x-2 sm:justify-between justify-end">
                                <!-- Filter -->
                                <VFilter @search="searchHandle" @apply="applyFilter" @clear="clearFilter"/>
                            </div>
                        </header>

                        <VDataTable :heads="heads" :isLoading="isLoadingAttendance" wrapperClass="!px-0">
                            <tr v-if="isLoadingAttendance">
                                <td class="h-[100%] overflow-hidden my-2" :colspan="heads.length">
                                    <VLoading />
                                </td>
                            </tr>
                            <tr v-else-if="query.length === 0 && !isLoadingAttendance">
                                <td class="overflow-hidden my-2" :colspan="heads.length">
                                    <div class="flex items-center flex-col w-full my-32">
                                        <VEmpty />
                                        <div class="mt-9 text-slate-500 text-xl md:text-xl font-medium">Result not
                                            found.</div>
                                    </div>
                                </td>
                            </tr>
                            <tr v-for="(data, index) in query" :key="index" v-else>
                                <td class="px-4 whitespace-nowrap h-16"> {{ data.date_formatted }} </td>
                                <td class="px-4 whitespace-nowrap h-16"> {{ data.clock_in }} </td>
                                <td class="px-4 whitespace-nowrap h-16"> {{ data.clock_out }} </td>
                                <td class="px-4 whitespace-nowrap h-16"> {{ data.work_hours }} </td>
                                <td class="px-4 whitespace-nowrap h-16 capitalize"> 
                                    <VBadge :text="data.status.replace(/_/g, ' ')" :color="getTypeStatus(data.status)" :icon="getIconStatus(data.status)" size="sm" />
                                </td>
                            </tr>
                        </VDataTable>
                        <div class="py-6">
                            <VPagination :pagination="pagination" @next="nextPaginate" @previous="previousPaginate" />
                        </div>
                    </section>
                </div>
            </div>
        </div>
    </div>

    <!-- OverTime -->
    <div class="bg-white shadow-lg rounded-sm border border-slate-200" :class="isLoadingOT && 'min-h-[40vh] sm:min-h-[50vh]'">
        <header class="block justify-between items-center sm:flex py-6 px-4">
            <h2 class="font-semibold text-slate-800">
                Submitting Overtime <span class="text-slate-400 !font-medium ml">{{ paginationOT.total }}</span>
            </h2>
        </header>

        <VDataTable :heads="headsOT" :isLoading="isLoadingOT">
            <tr v-if="isLoadingOT">
                <td class="h-[100%] overflow-hidden my-2" :colspan="headsOT.length">
                    <VLoading />
                </td>
            </tr>
            <tr v-else-if="query2.length === 0 && !isLoadingOT">
                <td class="overflow-hidden my-2" :colspan="headsOT.length">
                    <div class="flex items-center flex-col w-full my-32">
                        <VEmpty />
                        <div class="mt-9 text-slate-500 text-xl md:text-xl font-medium">Result not found.</div>
                    </div>
                </td>
            </tr>
            <tr v-for="(data, index) in query2" :key="index" v-else>
                <td class="px-4 whitespace-nowrap h-16 capitalize"> Approval Lembur </td>
                <td class="px-4 whitespace-nowrap h-16 capitalize">
                    <VBadge :text="data.status" :color="getStatusValueOT(data.status)" size="sm" />
                </td>
                <td class="px-4 whitespace-nowrap h-16"> {{ data.created_by }} </td>
                <td class="px-4 whitespace-nowrap h-16"> {{ data.created_at }} </td>
                <td class="px-4 whitespace-nowrap h-16"> {{ data.branch }} </td>
            </tr>
        </VDataTable>
        <div class="px-4 py-6">
            <VPagination :pagination="paginationOT" @next="nextPaginateOT" @previous="previousPaginateOT" />
        </div>
    </div>
</template>