<style scoped lang="scss">
</style>

<template lang="pug">
  .container.mt-2
    | {{ lot_question.question }}

    form(ref="form", method="post", @submit.prevent="confirmSubmit")
      textarea-field.mt-2(
        v-model="lot_question.answer",
        name="lot_question[answer]",
        :label="$t('.form.fields.answer_label')",
        :error="errors.question",
        require=true,
        :rows="10"
      )

      button.button-submit.button-long.u-full-width(
        type="submit",
        :disabled="submitting"
      )
        | {{ submitText }}
</template>

<script>
  export default {
    name: 'editLotQuestions',

    data () {
      return {
        i18nScope: 'biddings.lots.lot_questions.edit',
        errors:  {},
        lot_question: {},
        submitting: false,

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

    computed: {
      submitText() {
        if (this.submitting) return this.$t('.button.submitting')
        return this.$t('.button.submit')
      }
    },

    methods: {
      getLotQuestion() {
        return this.$http.get('/cooperative/biddings/' + this.biddingId + '/lots/' + this.lotId + '/lot_questions/' + this.$route.params.id)
          .then((response) => {
            this.lot_question = response.data

          }).catch((_err) => {
            this.error = _err
            console.error(_err)
          })
      },


      parseRoute() {
        this.biddingId = this.$params.asInteger(this.$route.params.bidding_id)
        this.lotId = this.$params.asInteger(this.$route.params.lot_id)
        this.lotQuestionId = this.$params.asInteger(this.$route.params.id)
      },

      confirmSubmit() {
        let message = {
          title: this.$t('.confirm.title'),
          body: this.$t('.confirm.body')
        }

        let options = {
          cancelText: this.$t('.dialog.back'),
          okText: this.$t('.dialog.confirm')
        }

        this.$dialog.confirm(message, options)
          .then((dialog) => {
            this.submit()
          })
          .catch(function (err) {
            console.log(err)
          });
      },

      submit() {
        const formData = new FormData(this.$refs.form)
        this.submitting = true

        this.$http.patch('/cooperative/biddings/' + this.biddingId + '/lots/' + this.lotId + '/lot_questions/' + this.lotQuestionId, formData)
          .then((response) => {
            this.$notifications.clear()
            this.errors = {}

            this.$router.replace({ name: 'LotQuestions', params: { bidding_id: this.biddingId, lot_id: this.lotId } })
          })
          .catch((err) => {
            let errors = _.dig(err, 'response', 'data', 'errors') || {}

            this.$notifications.error(this.$t('.notifications.failure'))
            this.errors = this.$i18n.errify(errors, { model: 'lot_question' })
          })
          .then(() => {
            this.submitting = false
          })
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
        this.getLotQuestion()
        this.updateTabsRoutes()
        this.updateTitle()
      }
    },

    created: function () {
      this.init();
    }
  }

</script>