<style scoped lang="scss">
</style>

<template lang="pug">
  .container.mt-2
    .card.slim.mb-2(v-if="this.lotQuestionsCount > 0")
      ul.mb-0
        li.list-item.row.p-1(v-for="lotQuestion in lotQuestions", @click="editLotQuestionPath(lotQuestion)")
          .container
            .list-title
              | {{ lotQuestion.question }}
            span(v-if="lotQuestion.answer")
              | {{ lotQuestion.answer }}
            span(v-else)
              | {{ $t('.waiting_answer') }}

    span(v-if="this.lotQuestionsCount == 0")
      | {{ $t('.no_lot_questions') }}

</template>

<script>
  export default {
    name: 'lotQuestions',

    data () {
      return {
        i18nScope: 'biddings.lots.lot_questions.index',
        lotQuestions: null,
        lotQuestionsCount: 0,
        isLoading: true,

        tabs: [
          {
            route: { name: 'bidding', params: {} },
            icon: 'fa-file',
            text: this.$t('models.bidding.one'),
            active: false,
          },

          {
            route: { name: 'lots', params: { bidding_id: null } },
            icon: 'fa-list',
            text: this.$t('biddings.lots.index.tabs.lots'),
            active: true,
          },

          {
            route: { name: 'invites', params: {} },
            icon: 'fa-envelope',
            text: this.$t('biddings.lots.index.tabs.invites'),
            active: false,
          }
        ]
      }
    },

    methods: {
      fetch() {
        this.isLoading = true

        return this.$http.get('/cooperative/biddings/' + this.biddingId + '/lots/' + this.lotId + '/lot_questions')
          .then((response) => {
            this.lotQuestions = response.data
            this.lotQuestionsCount = this.lotQuestions.length
            this.isLoading = false

          }).catch((_err) => {
            this.error = _err
            console.error(_err)
          })
      },

      editLotQuestionPath(lot_question) {
        if (lot_question.answer != null) {
          return '#!'
        }
        
        this.$router.push({ name: 'EditLotQuestion', params: { bidding_id: this.biddingId, lot_id: this.lotId, id: lot_question.id } })
      },

      parseRoute() {
        this.biddingId = this.$params.asInteger(this.$route.params.bidding_id)
        this.lotId = this.$params.asInteger(this.$route.params.lot_id)
      },

      updateTabsRoutes() {
        this.tabs[0].route.params = { id: this.biddingId }
        this.tabs[1].route.params = { bidding_id: this.biddingId }
        this.tabs[2].route.params = { bidding_id: this.biddingId, lot_id: this.lotId }

        this.$emit('tabChanged', this.tabs)
      },

      updateTitle() {
        this.$emit('navbarTitleChanged', this.$t('.title'))
      },

      init() {
        this.parseRoute()
        this.updateTitle()
        this.updateTabsRoutes()
        this.fetch()
      }      
    },

    created: function () {
      this.init();
    }
  }
</script>
